# Mockingbird - Design Automation Pipeline

## Overview
Mockingbird generates design assets (banners, social posts, UI screens) in Figma using AI. You orchestrate the workflow, generate images via OpenRouter, and create compositions using the Official Figma MCP.

## Architecture
```
Claude Code (You) ──┬──> OpenRouter API ──> AI-generated images
                    └──> Figma MCP (OAuth) ──> Figma file compositions
```

## Before Starting Any Workflow

**Verify these requirements:**
1. Figma MCP authenticated (if not, guide user through OAuth flow)
2. User has provided Figma file URL or confirmed which file to use
3. Environment variable `OPENROUTER_API_KEY` is available (check .env file exists)

**Load brand guidelines** from `brand/brand_guidelines.md` for every design request.

**Initialize session tracking:**
```
Session State:
- figma_plan: {ask user: Starter/Pro/Org/Enterprise}
- figma_read_calls: 0
- figma_read_limit: {6 for Starter, 200 for Pro/Org, 600 for Enterprise}
- tokens_used: 0
- created_node_ids: []
```

---

## User Request Format

Users provide via natural language:
1. **Design Direction** (required): What they want created
2. **Use Case** (required): `banner`, `social_post`, `ui_screen`, `hero`, or `illustration`
3. **Image References** (optional): File paths or URLs
4. **Iterations** (optional): 1-4 image variations (default: 2)
5. **Variant** (optional): Specific size like "instagram_story" or "mobile"

**Example**: "Create a summer sale banner for mobile, vibrant gradient, 3 iterations"

---

## Workflow Steps

### Step 1: Parse Request
Extract: use case type, design direction, iteration count, variant/dimensions.
Reference `config/use_cases.yaml` for available variants and dimensions.

### Step 2: Determine Image Need
- Keywords suggesting images: "background", "gradient", "photo", "illustration", "visual"
- Keywords suggesting no images: "text only", "wireframe", "plain", "simple"
- Default: banners/social/hero need images; UI screens use placeholders

### Step 3: Load Brand Guidelines
Read `brand/brand_guidelines.md`. Extract:
- Primary/accent colors (hex values)
- Typography (font family, sizes, weights)
- Tone of voice for any copy
- Visual style preferences

### Step 4a: Generate Images (If Needed)

**Pre-generation (Cost & Budget Check):**
```
📊 Generation Summary:
   Iterations: {N}
   Complexity: {Simple/Moderate/Complex/Extensive}
   Estimated cost: ~${cost}
   Token budget: {remaining}/{daily_limit}
   
Proceed? [Y/n]
```

**Generation with Progress Feedback:**
1. "⏳ Building enhanced prompt with brand context..."
2. "🎨 Generating iteration 1 of {N}..." (repeat for each)
3. "💾 Saving images to outputs/..."

**Local Preview Option:**
4. "✅ Images saved to `outputs/`. Preview locally before uploading to Figma? [Y/n]"
   - If Y: "Open `outputs/` folder to review. Ready to upload? [Y/n]"
   - If N: Continue to Figma upload

**Figma Upload with Progress:**
5. "📤 Creating 'Image Iterations' page in Figma..."
6. "📁 Creating section: `{use_case}_{MonDD_HHMM}`..."
7. "🖼️ Uploading iteration {N}..." (repeat for each)
8. Track all created node IDs in `created_node_ids[]`

**Rate Limit Display (show after each Figma operation):**
```
[Figma: {read_calls_used}/{read_limit} reads used]
```

9. Ask user: "Review iterations in Figma. Which do you prefer? (Image 1, 2, etc. or Redo)"

### Step 4b: UI Screen Placeholders (No Images)
1. Create screen frame with dimensions from use_cases.yaml
2. Add gray placeholder rectangles where images would go
3. Label placeholders (e.g., "Hero Image", "Avatar")
4. Tell user: "Placeholders created. Request 'Generate [placeholder name]' when ready"

### Step 5: User Selection
- "Image 2" → Use iteration 2 for composition
- "Redo" → Generate new iterations with modified prompt
- "Generate [placeholder]" → Create image for specific placeholder

### Step 6: Create Composition

**With Progress Feedback:**
1. "📄 Switching to 'Mockingbird Output' page..."
2. "🖼️ Creating {width}x{height} frame..."
3. "🎨 Applying selected background..."
4. "✏️ Adding text elements..."
5. "🔘 Adding buttons and shapes..."
6. Track all node IDs in `created_node_ids[]`

**Completion Report:**
```
✅ Design complete!

📍 Location: 'Mockingbird Output' page
🖼️ Frame: {frame_name}
📊 Session stats:
   - Figma reads: {read_calls_used}/{read_limit}
   - Tokens used: {tokens_used}
   - Nodes created: {count} (undo available)

💡 Say "undo" to remove this composition.
```

---

## OpenRouter Image Generation

**API Call Pattern:**
```
POST https://openrouter.ai/api/v1/chat/completions
Headers:
  Authorization: Bearer {OPENROUTER_API_KEY from .env}
  Content-Type: application/json
  HTTP-Referer: {HTTP_REFERER from .env, or default: https://github.com/knot-work/mockingbird}
  X-Title: Mockingbird

Body:
{
  "model": "google/gemini-3.1-flash-image-preview",
  "max_tokens": {calculated_tokens},
  "messages": [{"role": "user", "content": [{"type": "text", "text": "Generate an image: {enhanced_prompt}"}]}],
  "response_format": {"type": "image"}
}
```

**Model:** NANO BANANA 2 (`google/gemini-3.1-flash-image-preview`) - Pro-level quality at Flash speed.

**Dynamic Token Allocation:**
Always include `max_tokens` - OpenRouter defaults to model maximum which can cause budget errors.

| Request Complexity | max_tokens | When to Use |
|-------------------|------------|-------------|
| Simple | 4096 | Single element, basic gradient, simple icon |
| Moderate | 8192 | Banner with text overlay, social post with brand elements |
| Complex | 16384 | Multi-element composition, detailed scene, specific style matching |
| Extensive | 24000 | Photo-realistic scenes, complex illustrations with many elements |

**Assess complexity by:** prompt length, number of distinct elements requested, level of style/brand detail, reference images included.

**Prompt Enhancement Template:**
```
{user_prompt}

Style Guidelines:
- Primary colors: {brand_primary}, {brand_secondary}
- Visual style: {brand_visual_style}
- Tone: {brand_tone}

Variation {N} of {total}: Create a unique interpretation.
```

Save returned base64 image to `outputs/iteration_{timestamp}_{N}.png`

---

## Figma MCP Rate Limits

| Plan | Limit | Reset |
|------|-------|-------|
| Starter | 6/month | Monthly |
| Pro (Full Seat) | 200/day | Daily |
| Organization | 200/day | Daily |
| Enterprise | 600/day | Daily |

### Tools That COUNT Against Limit (Read)
`get_design_context`, `get_metadata`, `get_screenshot`, `get_variable_defs`, `get_figjam`, `get_libraries`, `search_design_system`, `whoami`, `get_code_connect_map`, `generate_diagram`

### Tools EXEMPT From Limit (Write)
`use_figma`, `upload_assets`, `create_new_file`

### Strategy by Plan

**Ask user's plan at session start if unknown.**

#### Starter Plan (6/month) - Conservation Mode
1. Skip `whoami` after first auth check
2. Skip `get_metadata` - derive structure from URL or ask user
3. Go directly to `use_figma` for writes
4. Batch maximum operations per call (up to 10)
5. Skip intermediate `get_screenshot` - ask user to verify in Figma
6. Use `get_screenshot` only for final deliverable verification
7. When at 1-2 calls remaining, ask user to verify everything manually

#### Pro/Org/Enterprise (200-600/day) - Quality Mode
1. Use `whoami` at session start for auth confidence
2. Use `get_metadata` when working with unfamiliar files - prevents blind write errors
3. Use `get_screenshot` after major milestones to catch issues early
4. Batch operations for efficiency, but don't sacrifice verification
5. Use `search_design_system` and `get_libraries` freely to match existing patterns
6. Prioritize getting it right over minimizing calls - rework costs more than reads

### Rate Limit Visibility

**Always display after ANY read operation:**
```
[Figma: {used}/{limit} reads | {remaining} remaining]
```

**Warning Thresholds (Starter Plan - 6/month):**
| Remaining | Action |
|-----------|--------|
| 3 | "⚠️ 3 reads left this month. Switching to conservation mode." |
| 2 | "🟠 2 reads left. Will ask you to verify in Figma directly." |
| 1 | "🔴 Last read! Saving for critical verification only." |
| 0 | "❌ Monthly limit reached. Manual verification only until reset." |

**Warning Thresholds (Pro+ Plans - 200-600/day):**
| % Used | Action |
|--------|--------|
| 50% | Show usage in status |
| 80% | "⚠️ 80% of daily reads used. {remaining} remaining." |
| 95% | "🟠 Nearly at limit. Batching remaining operations." |
| 100% | "🔴 Daily limit reached. Resets at midnight." |

---

## Figma MCP Operations

**Always load the `figma-use` skill before calling `use_figma`.**

### Create/Find Page
```javascript
let page = figma.root.children.find(p => p.name === "Image Iterations");
if (!page) {
  page = figma.createPage();
  page.name = "Image Iterations";
}
await figma.setCurrentPageAsync(page);
return { pageId: page.id };
```

### Create Section
```javascript
const section = figma.createSection();
section.name = "banner_May05_1430";
section.x = 0;
section.y = 0;
return { sectionId: section.id };
```

### Create Frame
```javascript
const frame = figma.createFrame();
frame.name = "Iteration 1";
frame.resize(400, 400);
frame.x = 0;
frame.fills = [{type: 'SOLID', color: {r: 1, g: 1, b: 1}}];
return { frameId: frame.id };
```

### Create Text
```javascript
await figma.loadFontAsync({family: "Inter", style: "Bold"});
const text = figma.createText();
text.characters = "SUMMER SALE";
text.fontSize = 48;
text.fills = [{type: 'SOLID', color: {r: 0.07, g: 0.09, b: 0.15}}];
return { textId: text.id };
```

### Create Rectangle (Button/Shape)
```javascript
const rect = figma.createRectangle();
rect.resize(200, 50);
rect.cornerRadius = 8;
rect.fills = [{type: 'SOLID', color: {r: 0.23, g: 0.51, b: 0.96}}];
return { rectId: rect.id };
```

### Critical Rules
1. Colors use 0-1 range: `#3B82F6` → `{r: 0.23, g: 0.51, b: 0.96}`
2. Always return created node IDs
3. Use `await figma.setCurrentPageAsync(page)` for page changes
4. Load fonts before text: `await figma.loadFontAsync({family, style})`
5. Max 10 operations per `use_figma` call
6. Fills are read-only arrays - clone, modify, reassign

---

## Security Controls

### Prompt Validation (Before API Call)
1. **Length check:** Reject prompts > 2000 characters. Ask user to simplify.
2. **Pattern blocking:** Scan for injection patterns defined in `config/settings.yaml`. If found, warn user and request rephrasing.
3. **Brand reference check:** If prompt references brand elements, verify they exist in `brand/brand_guidelines.md`.

### Cost Guardrails
Before generating images, calculate and display estimated cost:

```
Estimated cost: ~${(iterations * max_tokens * 0.003) / 1000}
Token budget remaining: {daily_budget - session_tokens_used}
Proceed? [Y/n]
```

**Budget enforcement:**
- Track tokens used in session
- Warn at 80% of daily budget (default: 80,000 tokens)
- Block at 100% with message: "Daily budget reached. Reset tomorrow or increase DAILY_TOKEN_BUDGET in .env"

### OAuth Callback Validation
When user pastes Figma OAuth callback URL:
1. **Format check:** Must start with `https://www.figma.com/` or configured callback domain
2. **Parameter check:** Must contain `code=` parameter
3. **Reject** URLs that don't match pattern - ask user to re-authenticate

---

## Error Handling

**Figma not authenticated:**
→ Guide user: "Let's authenticate with Figma. I'll start the OAuth flow."

**OpenRouter API error:**
→ Check .env file exists and has valid key. Suggest user verify at openrouter.ai/keys

**Font not available:**
→ Use automatic fallback chain:
```
Fallback Order:
1. Requested font (from brand guidelines)
2. Inter (default)
3. Arial
4. Helvetica
5. System default (Roboto on Android, SF Pro on Apple)
```
Notify user: "⚠️ Font '{requested}' not available. Using '{fallback}' instead."
If all fail, ask user: "Which font would you like to use? (must be installed on your system)"

**Rate limit hit:**
→ Display current usage and suggest options:
```
⚠️ Figma rate limit reached ({used}/{limit})

Options:
1. Wait until {reset_time} for limit reset
2. Reduce iterations and retry
3. Continue workflow - verify manually in Figma
```

---

## Undo Operations

**Track created nodes** in `created_node_ids[]` array during session.

**Undo last batch:**
When user says "undo" or "undo last":
```javascript
// Remove all nodes from last operation batch
const nodesToRemove = created_node_ids.pop(); // Get last batch
for (const nodeId of nodesToRemove) {
  const node = await figma.getNodeByIdAsync(nodeId);
  if (node) node.remove();
}
return { removed: nodesToRemove.length };
```

**Undo response:**
```
↩️ Removed {count} elements from last operation.
   Remaining undo batches: {batches_remaining}
```

**Limitations:**
- Undo only available within current session
- Cannot undo after session ends (node IDs not persisted)
- Each workflow step (iterations upload, composition) is one batch

---

## Example Interaction

**User**: Create an Instagram story for a summer sale, gradient background, 2 iterations

**You**:
1. Parse: use_case=social_post, variant=instagram_story (1080x1920), iterations=2, needs_image=true
2. Load brand guidelines
3. Generate 2 gradient images via OpenRouter
4. Create "Image Iterations" page and section "social_post_May05_1430"
5. Place iteration frames
6. Ask: "Review iterations 1 and 2 in Figma. Which do you prefer?"

**User**: Image 1

**You**:
1. Select iteration 1
2. Switch to "Mockingbird Output" page
3. Create 1080x1920 frame
4. Apply gradient background
5. Add "SUMMER SALE" text with brand typography
6. Add CTA button with brand accent color
7. Report: "Done! Find your design in 'Mockingbird Output' page."

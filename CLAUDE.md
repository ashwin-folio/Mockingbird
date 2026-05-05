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
1. Build enhanced prompt with brand context
2. Call OpenRouter API for each iteration
3. Save images to `outputs/` directory
4. Create "Image Iterations" page in Figma (if doesn't exist)
5. Create section: `{use_case}_{MonDD_HHMM}` (e.g., "banner_May05_1430")
6. Place iteration frames labeled "1", "2", "3", "4"
7. Ask user: "Review iterations in Figma. Which do you prefer? (Image 1, 2, etc. or Redo)"

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
1. Switch to "Mockingbird Output" page (create if needed)
2. Create main frame with use case dimensions
3. Apply selected background image
4. Add text elements with brand typography
5. Add shapes, buttons with brand colors
6. Confirm completion and location

---

## OpenRouter Image Generation

**API Call Pattern:**
```
POST https://openrouter.ai/api/v1/chat/completions
Headers:
  Authorization: Bearer {OPENROUTER_API_KEY from .env}
  Content-Type: application/json
  HTTP-Referer: https://github.com/knot-work/mockingbird
  X-Title: Mockingbird

Body:
{
  "model": "google/gemini-2.5-flash-image",
  "max_tokens": {calculated_tokens},
  "messages": [{"role": "user", "content": [{"type": "text", "text": "Generate an image: {enhanced_prompt}"}]}],
  "response_format": {"type": "image"}
}
```

**Dynamic Token Allocation:**
Always include `max_tokens` - OpenRouter defaults to model maximum which exceeds free tier budgets.

| Request Complexity | max_tokens | When to Use |
|-------------------|------------|-------------|
| Simple | 4096 | Single element, basic gradient, simple icon |
| Moderate | 8192 | Banner with text overlay, social post with brand elements |
| Complex | 16384 | Multi-element composition, detailed scene, specific style matching |
| Extensive | 24000 | Photo-realistic scenes, complex illustrations with many elements |

**Assess complexity by:** prompt length, number of distinct elements requested, level of style/brand detail, reference images included.

**Available Models:**
- `google/gemini-2.5-flash-image` (recommended, free tier compatible)
- `google/gemini-3.1-flash-image-preview` (better quality, requires paid credits)

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

## Error Handling

**Figma not authenticated:**
→ Guide user: "Let's authenticate with Figma. I'll start the OAuth flow."

**OpenRouter API error:**
→ Check .env file exists and has valid key. Suggest user verify at openrouter.ai/keys

**Font not available:**
→ Fall back to "Inter" or ask user for alternative font

**Rate limit hit:**
→ Wait and retry, or reduce iteration count

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

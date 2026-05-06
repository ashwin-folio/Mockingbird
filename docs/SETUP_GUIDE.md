# Mockingbird Setup Guide

A step-by-step guide for designers with no technical background.

---

## What You'll Need

Before starting, make sure you have:
- A computer (Windows, Mac, or Linux)
- Internet connection
- About 15 minutes

---

## Step 1: Install Claude Code

Claude Code is the terminal app that runs Mockingbird.

### Windows
1. Download from: https://claude.ai/download
2. Run the installer
3. Follow the installation prompts
4. Sign in with your Anthropic account

### Mac
1. Download from: https://claude.ai/download
2. Open the .dmg file
3. Drag Claude Code to Applications
4. Open from Applications
5. Sign in with your Anthropic account

### Verify Installation
Open Terminal (Mac) or PowerShell (Windows) and type:
```
claude --version
```
You should see a version number.

---

## Step 2: Get OpenRouter API Key

OpenRouter provides the AI that generates images.

1. Go to https://openrouter.ai
2. Click "Sign Up" (or "Log In" if you have an account)
3. Once logged in, click your profile → "Keys"
4. Click "Create Key"
5. Name it "Mockingbird"
6. Click "Create"
7. **Copy the key** (starts with "sk-or-")
8. **Save it somewhere safe** - you'll need it in the next step

### Add Credits
1. In OpenRouter, go to "Credits"
2. Add at least $5 to start (images cost ~$0.10-0.15 each)

---

## Step 3: Download Mockingbird

Get the Mockingbird files:

**Option A: Download ZIP**
1. Download the Mockingbird.zip file
2. Extract to a location you'll remember (e.g., Documents/Mockingbird)

**Option B: Git Clone** (if you use Git)
```
git clone [repository-url] Mockingbird
```

---

## Step 4: Configure Your API Key

1. Open the Mockingbird folder
2. Find the file named `.env.example`
3. **Make a copy** and rename it to `.env`
4. Open `.env` in a text editor (Notepad, TextEdit, VS Code)
5. Replace `sk-or-your-key-here` with your actual OpenRouter key:

```
OPENROUTER_API_KEY=sk-or-v1-abc123yourActualKeyHere
```

6. Save the file

**Important:** Never share your .env file or post your API key online.

---

## Step 5: Customize Brand Guidelines (Optional)

If you want designs to match your brand:

1. Open `brand/brand_guidelines.md`
2. Replace the default colors with your brand colors
3. Update typography to match your brand fonts
4. Save the file

You can always do this later.

---

## Step 6: Run Mockingbird

### Windows
1. Open PowerShell
2. Navigate to Mockingbird folder:
   ```
   cd "C:\Users\YourName\Documents\Mockingbird"
   ```
3. Start Claude Code:
   ```
   claude
   ```

### Mac/Linux
1. Open Terminal
2. Navigate to Mockingbird folder:
   ```
   cd ~/Documents/Mockingbird
   ```
3. Start Claude Code:
   ```
   claude
   ```

---

## Step 7: Connect to Figma

You have two options for connecting to Figma:

### Option A: Plugin Bridge (Recommended - No Rate Limits)

The Plugin Bridge uses Figma's local Plugin API, which has **no rate limits**. Best for:
- Starter plan users (only 6 API calls/month on official MCP)
- High-volume design generation
- Anyone who wants unlimited operations

**Setup:**

1. **Add MCP server to Claude Code config**
   - Open `.claude/settings.json` (create it if needed)
   - Add:
   ```json
   {
     "mcpServers": {
       "figma-bridge": {
         "command": "npx",
         "args": ["-y", "@gethopp/figma-mcp-bridge"]
       }
     }
   }
   ```

2. **Install the Figma plugin**
   - Download the plugin from: https://github.com/gethopp/figma-mcp-bridge/releases
   - Extract the ZIP file
   - In Figma Desktop: `Plugins → Development → Import plugin from manifest`
   - Select the `manifest.json` from the extracted `plugin/` folder

3. **Start using it**
   - Open your Mockingbird Figma file
   - Run the plugin: `Plugins → Development → Figma MCP Bridge`
   - Keep the plugin window open during your session
   - Start designing with Claude Code!

**Note:** The plugin must stay open in Figma while you work. If it disconnects, just re-run it.

### Option B: Official Figma MCP (OAuth)

The traditional approach using Figma's REST API. Has rate limits based on your plan.

On your first run, Claude will help you connect to Figma:

1. Claude will say "Let's authenticate with Figma"
2. A link will appear - click it
3. Your browser opens to Figma's authorization page
4. Click "Allow"
5. You'll be redirected to a page with a callback URL
6. Copy the entire URL from your browser
7. Paste it back into Claude Code

**Rate Limits (Official MCP only):**
| Plan | Limit |
|------|-------|
| Starter | 6/month |
| Pro | 200/day |
| Enterprise | 600/day |

**That's it!** Figma is now connected.

---

## Step 8: Create Your First Design

Try this command:
```
Create a mobile banner for summer sale, gradient background
```

Claude will:
1. Generate 2 image options
2. Show them in Figma
3. Ask which you prefer
4. Create the final composition

---

## Troubleshooting

### "OPENROUTER_API_KEY not found"
- Make sure you renamed `.env.example` to `.env`
- Make sure the key is on the line starting with `OPENROUTER_API_KEY=`
- Make sure there are no spaces around the `=` sign

### "Figma authentication failed" (Official MCP)
- Make sure you're logged into Figma in your browser
- Try the authentication again
- Make sure you copied the complete callback URL

### "Plugin Bridge not connecting"
- Make sure Figma Desktop is open (not browser Figma)
- Ensure the plugin is running (should show "Connected" status)
- Restart Claude Code after adding the MCP config
- Check that npx can run: try `npx -y @gethopp/figma-mcp-bridge` in terminal

### "Font not available"
- Mockingbird defaults to "Inter" font
- Make sure Inter is installed on your system, or
- Update `brand/brand_guidelines.md` with fonts you have

### Need more help?
See `docs/TROUBLESHOOTING.md` for more solutions.

---

## Next Steps

- Read `docs/WORKFLOW_GUIDE.md` for usage tips
- Customize `brand/brand_guidelines.md` for your brand
- Explore different use cases: banners, social posts, UI screens

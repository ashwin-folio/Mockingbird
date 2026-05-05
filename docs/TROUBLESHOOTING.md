# Troubleshooting Guide

Solutions for common Mockingbird issues.

---

## API Key Issues

### "OPENROUTER_API_KEY not found"

**Cause:** The .env file is missing or misconfigured.

**Fix:**
1. Check that `.env` file exists in the Mockingbird folder (not `.env.example`)
2. Open `.env` and verify the format:
   ```
   OPENROUTER_API_KEY=sk-or-v1-yourActualKey
   ```
3. No spaces around the `=` sign
4. No quotes around the key value
5. Restart Claude Code after changes

### "Invalid API key" or "Unauthorized"

**Cause:** The API key is incorrect or expired.

**Fix:**
1. Go to https://openrouter.ai/keys
2. Verify your key is active
3. If in doubt, create a new key
4. Update `.env` with the new key

### "Insufficient credits"

**Cause:** Your OpenRouter account needs more credits.

**Fix:**
1. Go to https://openrouter.ai
2. Click Credits
3. Add funds ($5 minimum recommended)

---

## Figma Connection Issues

### "Figma authentication failed"

**Cause:** OAuth flow didn't complete properly.

**Fix:**
1. Make sure you're logged into Figma in your browser
2. Start fresh: tell Claude "Let's authenticate with Figma again"
3. When the link appears, make sure to:
   - Click "Allow" on Figma's authorization page
   - Copy the COMPLETE URL from the redirect page
   - Paste it back to Claude

### "Cannot find Figma file"

**Cause:** The file URL is incorrect or you don't have access.

**Fix:**
1. Open the file in Figma
2. Copy the URL from your browser
3. Share the complete URL with Claude
4. Make sure you have edit access to the file

### "Permission denied" when creating in Figma

**Cause:** You only have view access to the file.

**Fix:**
1. Ask the file owner for edit access, or
2. Duplicate the file to your own drafts

---

## Image Generation Issues

### Images not generating

**Cause:** API timeout or model unavailable.

**Fix:**
1. Check your internet connection
2. Try again with fewer iterations (1 instead of 2-4)
3. If persistent, try: "Use a different image model"

### Low quality images

**Cause:** Prompt needs more detail.

**Fix:**
1. Be more specific in your design direction
2. Include style keywords: "professional", "modern", "vibrant"
3. Reference your brand guidelines explicitly

### Wrong style/colors

**Cause:** Brand guidelines not being applied.

**Fix:**
1. Check `brand/brand_guidelines.md` has correct colors
2. Explicitly mention colors in your request:
   "Create a banner using our brand blue (#3B82F6)"

---

## Font Issues

### "Font not available" error

**Cause:** The font specified in brand guidelines isn't installed.

**Fix Option 1:** Install the font
- Download Inter from https://fonts.google.com/specimen/Inter
- Install on your system

**Fix Option 2:** Change brand guidelines
- Open `brand/brand_guidelines.md`
- Change font to one you have (Arial, Helvetica, etc.)

### Text appears in wrong font

**Cause:** Font name mismatch between guidelines and Figma.

**Fix:**
- Use exact font names as they appear in Figma
- Common names: "Inter", "Roboto", "SF Pro", "Arial"

---

## Figma Output Issues

### Can't find the created design

**Look in these pages:**
1. "Image Iterations" page - for generated image options
2. "Mockingbird Output" page - for final compositions

### Design created in wrong location

**Fix:**
1. Specify the target: "Create in my 'Designs' page"
2. Or move the design manually in Figma after creation

### Elements overlapping or misaligned

**Cause:** Complex layouts may need manual adjustment.

**Fix:**
1. Tell Claude: "Adjust the layout - text is overlapping"
2. Or make manual tweaks in Figma

---

## Performance Issues

### Claude Code is slow

**Possible causes and fixes:**
1. Large Figma file - use a smaller file for iterations
2. Many iterations - reduce to 1-2
3. Internet connection - check your connection speed

### Session disconnected

**Fix:**
1. Restart Claude Code: `claude`
2. You may need to re-authenticate with Figma

---

## Getting More Help

If none of these solutions work:

1. **Check the error message** - copy the exact text
2. **Restart Claude Code** - sometimes a fresh start helps
3. **Verify your setup** - go through SETUP_GUIDE.md again
4. **Report an issue** - contact your team lead or IT support

---

## Quick Diagnostic Checklist

Run through this checklist to identify issues:

- [ ] `.env` file exists (not `.env.example`)
- [ ] OpenRouter API key starts with `sk-or-`
- [ ] OpenRouter account has credits
- [ ] Figma is authenticated (can see files)
- [ ] Have edit access to target Figma file
- [ ] Internet connection is stable
- [ ] Using supported fonts (Inter recommended)

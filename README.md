# Mockingbird

Design automation pipeline for creating banners, social posts, and UI screens in Figma using AI.

## Quick Start

### 1. Prerequisites
- [Claude Code](https://claude.ai/download) Pro or Max subscription
- [OpenRouter](https://openrouter.ai) account with credits
- Figma account (Free or paid)

### 2. Setup (5 minutes)

```bash
# Copy environment template
cp .env.example .env

# Edit .env and add your OpenRouter API key
# Get key from: https://openrouter.ai/keys
```

### 3. Run Mockingbird

```bash
# Navigate to Mockingbird folder
cd path/to/Mockingbird

# Start Claude Code
claude
```

### 4. First Run

When you start, Claude will:
1. Ask you to authenticate with Figma (one-time OAuth)
2. Ask which Figma file to use
3. You're ready to create designs!

## Usage Examples

**Create a banner:**
```
Create a mobile banner for summer sale, gradient background
```

**Create social media post:**
```
Create an Instagram story announcing new features, modern and clean, 3 iterations
```

**Create UI screen:**
```
Create a settings screen for mobile app
```

## Customization

Edit `brand/brand_guidelines.md` to match your brand:
- Colors (hex values)
- Typography (fonts, sizes)
- Tone of voice
- Visual style

## Folder Structure

```
Mockingbird/
├── CLAUDE.md          # Instructions for Claude (don't edit unless advanced)
├── .env               # Your API key (keep private!)
├── config/            # Settings and use case definitions
├── brand/             # Brand guidelines
├── docs/              # Detailed documentation
├── outputs/           # Generated images
└── scripts/           # Setup helpers
```

## Support

See `docs/TROUBLESHOOTING.md` for common issues.

## Cost Estimate

| Usage Level | Monthly Cost |
|-------------|--------------|
| Light (50 images) | ~$25-30 |
| Moderate (200 images) | ~$40-50 |
| Heavy (500 images) | ~$70-100 |

*Includes Claude Code Pro ($20) + OpenRouter image generation (~$0.10-0.15/image)*

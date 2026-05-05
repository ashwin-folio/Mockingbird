# Workflow Guide

How to get the most out of Mockingbird.

---

## Basic Workflow

### 1. Start a Request
Tell Claude what you want to create. Include:
- **What**: The type of design (banner, social post, UI screen)
- **Purpose**: What it's for (summer sale, product launch, settings page)
- **Style**: How it should look (vibrant, minimal, professional)

**Example:**
```
Create a mobile banner for our summer sale, vibrant gradient background
```

### 2. Review Iterations
Claude generates image options and places them in Figma:
- Open the "Image Iterations" page in Figma
- Look for the section with today's timestamp
- Compare the options (labeled 1, 2, 3, 4)

### 3. Select or Redo
Tell Claude your choice:
- "Image 2" - uses that option
- "Redo" - generates new options
- "Image 1, but make it more vibrant" - refines and regenerates

### 4. Get Final Composition
Claude creates the complete design in the "Mockingbird Output" page with:
- Your selected background
- Text with brand typography
- Buttons/CTAs with brand colors

---

## Use Cases

### Banners

**In-App Banners**
```
Create a mobile banner for flash sale, ends tonight
```

**Web Banners**
```
Create a leaderboard banner (728x90) for new feature announcement
```

**Variants available:**
- `mobile_small` (320x50)
- `mobile_large` (320x100)
- `tablet` (728x90)
- `web_leaderboard` (728x90)

### Social Media Posts

**Instagram Feed**
```
Create an Instagram post announcing our new product
```

**Instagram Story**
```
Create an Instagram story for behind-the-scenes content, 3 iterations
```

**LinkedIn**
```
Create a LinkedIn post about company milestone
```

**Variants available:**
- `instagram_square` (1080x1080)
- `instagram_story` (1080x1920)
- `linkedin` (1200x628)
- `twitter` (1200x675)

### UI Screens

**Mobile App Screens**
```
Create a settings screen for mobile app
```

**Desktop Screens**
```
Create a dashboard screen for desktop
```

UI screens use **placeholders** for images by default. You can later say:
```
Generate an image for the hero placeholder
```

**Variants available:**
- `mobile` (375x812)
- `mobile_android` (360x800)
- `tablet` (768x1024)
- `desktop` (1440x900)

### Hero Images

**Website Heroes**
```
Create a hero image for landing page, abstract tech theme
```

**Variants available:**
- `standard` (1920x600)
- `wide` (1920x800)
- `compact` (1440x400)

### Illustrations

**Custom Graphics**
```
Create a square illustration representing teamwork
```

**Variants available:**
- `square` (800x800)
- `landscape` (1200x800)
- `portrait` (800x1200)

---

## Advanced Tips

### Be Specific with Style
Instead of:
```
Create a banner
```

Try:
```
Create a mobile banner with gradient from blue to purple, 
bold white text saying "50% OFF", modern and clean style
```

### Reference Brand Guidelines
```
Create an Instagram post using our brand colors and Inter font
```

### Request More Iterations
Default is 2 iterations. Request more for variety:
```
Create a social post, 4 iterations so I have options
```

### Specify Exact Dimensions
```
Create a banner exactly 400x100 pixels
```

### Combine Elements
```
Create a mobile banner with:
- Gradient background (purple to pink)
- "FLASH SALE" as main text
- "Ends midnight" as subtext  
- "Shop Now" button
```

---

## Working with Iterations

### Selecting
```
Image 2
```

### Redoing with Feedback
```
Redo - make it more vibrant and energetic
```

### Combining Ideas
```
I like the colors from Image 1 but the layout of Image 3. 
Can you create a new version combining both?
```

### Saving for Later
All iterations are saved in:
- Figma: "Image Iterations" page (organized by sections)
- Local: `outputs/` folder

---

## Modifying Designs

### After Initial Creation
```
Move the text higher
Make the button larger
Change the background color to our accent green
Add more padding around the text
```

### Adding Elements
```
Add a logo in the top left corner
Add a "Limited Time" badge
```

### Removing Elements
```
Remove the subtext
Remove the button
```

---

## Working with UI Screens

### Initial Creation (with Placeholders)
```
Create a profile screen for mobile with:
- Header with avatar
- Name and bio section
- Stats row
- Action buttons
```

Claude creates the layout with gray placeholder boxes for images.

### Generating Images for Placeholders
```
Generate an avatar image for the profile placeholder
```

### Multiple Screens
```
Create a login screen
```
Then:
```
Now create the registration screen to match
```

---

## Best Practices

### 1. Start Simple, Refine
Begin with a basic request, then add details:
```
Create a banner for summer sale
```
Then:
```
Make it more vibrant with orange gradient
```

### 2. Use Consistent Terminology
Stick to use case names from the system:
- `banner` (not "ad" or "promo")
- `social_post` (not "social media image")
- `ui_screen` (not "mockup" or "wireframe")

### 3. Reference Previous Work
```
Create another banner like the last one but for winter sale
```

### 4. Keep Brand Guidelines Updated
Your designs are only as good as your brand guidelines. Keep `brand/brand_guidelines.md` current with:
- Accurate hex color codes
- Correct font names
- Updated style preferences

### 5. Organize in Figma
- Rename sections with meaningful names
- Move final designs to your project pages
- Delete iterations you don't need

---

## Quick Reference

| Request | Example |
|---------|---------|
| Banner | "Create a mobile banner for sale" |
| Social | "Create an Instagram story" |
| UI | "Create a settings screen" |
| Hero | "Create a hero image" |
| More options | "...3 iterations" |
| Specific size | "instagram_story variant" |
| Select | "Image 2" |
| Redo | "Redo with warmer colors" |
| Modify | "Make the text larger" |

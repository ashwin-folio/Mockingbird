# Figma MCP Commands Reference

Quick reference for common Figma operations via the Official Figma MCP.

---

## Authentication

Authentication is handled automatically via OAuth. If needed:
1. Claude detects Figma tools need authentication
2. Provides OAuth link to click
3. User authorizes in browser
4. User pastes callback URL back to Claude

---

## Page Operations

### Create Page
```javascript
const page = figma.createPage();
page.name = "My New Page";
await figma.setCurrentPageAsync(page);
return { pageId: page.id };
```

### Find Existing Page
```javascript
const page = figma.root.children.find(p => p.name === "Image Iterations");
if (page) {
  await figma.setCurrentPageAsync(page);
}
return { pageId: page?.id };
```

### Get Current Page
```javascript
const page = figma.currentPage;
return { pageId: page.id, pageName: page.name };
```

---

## Section Operations

### Create Section
```javascript
const section = figma.createSection();
section.name = "banner_May05_1430";
section.x = 0;
section.y = 0;
return { sectionId: section.id };
```

---

## Frame Operations

### Create Frame
```javascript
const frame = figma.createFrame();
frame.name = "Banner";
frame.resize(320, 100);
frame.x = 0;
frame.y = 0;
return { frameId: frame.id };
```

### Create Frame with Background Color
```javascript
const frame = figma.createFrame();
frame.name = "Card";
frame.resize(300, 200);
frame.fills = [{
  type: 'SOLID',
  color: { r: 1, g: 1, b: 1 }  // White
}];
return { frameId: frame.id };
```

---

## Shape Operations

### Create Rectangle
```javascript
const rect = figma.createRectangle();
rect.name = "Button";
rect.resize(200, 50);
rect.cornerRadius = 8;
rect.fills = [{
  type: 'SOLID',
  color: { r: 0.23, g: 0.51, b: 0.96 }  // #3B82F6
}];
return { rectId: rect.id };
```

### Create Ellipse
```javascript
const ellipse = figma.createEllipse();
ellipse.name = "Circle";
ellipse.resize(100, 100);
ellipse.fills = [{
  type: 'SOLID',
  color: { r: 0.06, g: 0.73, b: 0.51 }  // #10B981
}];
return { ellipseId: ellipse.id };
```

---

## Text Operations

### Create Text (Basic)
```javascript
await figma.loadFontAsync({ family: "Inter", style: "Regular" });
const text = figma.createText();
text.characters = "Hello World";
text.fontSize = 16;
return { textId: text.id };
```

### Create Styled Heading
```javascript
await figma.loadFontAsync({ family: "Inter", style: "Bold" });
const text = figma.createText();
text.characters = "SUMMER SALE";
text.fontSize = 48;
text.fills = [{
  type: 'SOLID',
  color: { r: 1, g: 1, b: 1 }  // White
}];
return { textId: text.id };
```

### Multi-Style Text
```javascript
await figma.loadFontAsync({ family: "Inter", style: "Bold" });
await figma.loadFontAsync({ family: "Inter", style: "Regular" });

const text = figma.createText();
text.characters = "Bold and Regular";
text.setRangeFontName(0, 4, { family: "Inter", style: "Bold" });
text.setRangeFontName(5, 16, { family: "Inter", style: "Regular" });
return { textId: text.id };
```

---

## Color Reference

### Hex to Figma RGB
Colors in Figma use 0-1 range, not 0-255.

| Hex | Figma RGB |
|-----|-----------|
| #3B82F6 | `{r: 0.23, g: 0.51, b: 0.96}` |
| #1F2937 | `{r: 0.12, g: 0.16, b: 0.22}` |
| #10B981 | `{r: 0.06, g: 0.73, b: 0.51}` |
| #6366F1 | `{r: 0.39, g: 0.40, b: 0.95}` |
| #FFFFFF | `{r: 1, g: 1, b: 1}` |
| #000000 | `{r: 0, g: 0, b: 0}` |

### Conversion Formula
```
r = parseInt(hex.slice(1,3), 16) / 255
g = parseInt(hex.slice(3,5), 16) / 255
b = parseInt(hex.slice(5,7), 16) / 255
```

---

## Layout Operations

### Position Node
```javascript
node.x = 100;
node.y = 50;
```

### Resize Node
```javascript
node.resize(400, 300);
```

### Auto Layout
```javascript
frame.layoutMode = "VERTICAL";  // or "HORIZONTAL"
frame.primaryAxisSizingMode = "AUTO";
frame.counterAxisSizingMode = "AUTO";
frame.paddingTop = 20;
frame.paddingBottom = 20;
frame.paddingLeft = 20;
frame.paddingRight = 20;
frame.itemSpacing = 16;
```

---

## Important Rules

1. **Color Range**: Always use 0-1 range (not 0-255)
2. **Return IDs**: Always return created node IDs
3. **Async Pages**: Use `await figma.setCurrentPageAsync(page)`
4. **Load Fonts**: Call `await figma.loadFontAsync()` before text operations
5. **Fills Array**: Fills are read-only - clone, modify, reassign
6. **Max Operations**: Keep to ~10 operations per `use_figma` call
7. **Load Skill**: Always invoke `figma-use` skill before `use_figma` calls

---

## Example: Complete Banner

```javascript
// Load fonts
await figma.loadFontAsync({ family: "Inter", style: "Bold" });
await figma.loadFontAsync({ family: "Inter", style: "Medium" });

// Create frame
const frame = figma.createFrame();
frame.name = "Summer Sale Banner";
frame.resize(320, 100);
frame.fills = [{
  type: 'SOLID',
  color: { r: 0.23, g: 0.51, b: 0.96 }
}];

// Add heading
const heading = figma.createText();
heading.characters = "SUMMER SALE";
heading.fontSize = 24;
heading.fills = [{ type: 'SOLID', color: { r: 1, g: 1, b: 1 } }];
frame.appendChild(heading);
heading.x = 20;
heading.y = 20;

// Add button
const button = figma.createRectangle();
button.name = "CTA Button";
button.resize(100, 32);
button.cornerRadius = 4;
button.fills = [{ type: 'SOLID', color: { r: 1, g: 1, b: 1 } }];
frame.appendChild(button);
button.x = 20;
button.y = 52;

// Add button text
const btnText = figma.createText();
btnText.characters = "Shop Now";
btnText.fontSize = 14;
btnText.fills = [{ type: 'SOLID', color: { r: 0.23, g: 0.51, b: 0.96 } }];
frame.appendChild(btnText);
btnText.x = 35;
btnText.y = 58;

return { frameId: frame.id };
```

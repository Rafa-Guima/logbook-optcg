---
name: LogBook
colors:
  surface: '#131313'
  surface-dim: '#131313'
  surface-bright: '#3a3939'
  surface-container-lowest: '#0e0e0e'
  surface-container-low: '#1c1b1b'
  surface-container: '#201f1f'
  surface-container-high: '#2a2a2a'
  surface-container-highest: '#353534'
  on-surface: '#e5e2e1'
  on-surface-variant: '#e4bebc'
  inverse-surface: '#e5e2e1'
  inverse-on-surface: '#313030'
  outline: '#ab8987'
  outline-variant: '#5b403f'
  surface-tint: '#ffb3b1'
  primary: '#ffb3b1'
  on-primary: '#680011'
  primary-container: '#ff535b'
  on-primary-container: '#5b000e'
  inverse-primary: '#bb152c'
  secondary: '#c5c7c8'
  on-secondary: '#2e3132'
  secondary-container: '#494c4d'
  on-secondary-container: '#babcbd'
  tertiary: '#6fd8cc'
  on-tertiary: '#003733'
  tertiary-container: '#2fa096'
  on-tertiary-container: '#00302c'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#ffdad8'
  primary-fixed-dim: '#ffb3b1'
  on-primary-fixed: '#410007'
  on-primary-fixed-variant: '#92001c'
  secondary-fixed: '#e1e3e4'
  secondary-fixed-dim: '#c5c7c8'
  on-secondary-fixed: '#191c1d'
  on-secondary-fixed-variant: '#454748'
  tertiary-fixed: '#8cf4e8'
  tertiary-fixed-dim: '#6fd8cc'
  on-tertiary-fixed: '#00201d'
  on-tertiary-fixed-variant: '#00504a'
  background: '#131313'
  on-background: '#e5e2e1'
  surface-variant: '#353534'
typography:
  display-lg:
    fontFamily: Montserrat
    fontSize: 40px
    fontWeight: '800'
    lineHeight: 48px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Montserrat
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
  headline-lg-mobile:
    fontFamily: Montserrat
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 34px
  headline-md:
    fontFamily: Montserrat
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
  title-lg:
    fontFamily: Montserrat
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-bold:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '700'
    lineHeight: 16px
  label-sm:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '500'
    lineHeight: 14px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  unit: 4px
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 32px
  gutter: 16px
  margin-mobile: 20px
---

## Brand & Style

The design system targets the Brazilian *One Piece Card Game* community, blending the high-energy excitement of the anime with the organized precision of a professional trading card tool. The brand personality is **Modern, Bold, and Premium**, ensuring that rare card collectors and competitive players feel they are using a high-value utility rather than a simple fan site.

The visual style is **Corporate Modern with a Bold twist**. It utilizes heavy whitespace and a restricted color palette to maintain clarity, while using high-impact typography and saturated primary accents to evoke the spirit of the source material. The interface must feel fast, responsive, and authoritative—acting as a reliable "log" for a player's journey.

## Colors

The palette is anchored by "Grand Line Red," a vibrant and aggressive primary color used for critical actions and brand markers. While the system supports light mode, the primary experience is optimized for **Dark Mode** to reduce eye strain during long deck-building sessions and to allow the vibrant colors of the digital card art to pop.

- **Primary (#E63946):** Used for primary buttons, active states, and critical brand elements.
- **Background (#0D0D0D):** A deep, near-black that provides maximum contrast for white text and card frames.
- **Surface (#1A1A1A):** A slightly lighter gray used for card containers and elevated surfaces to create depth.
- **Text (#FFFFFF):** High-contrast white for maximum legibility.
- **Accent Gold (#FFD700):** Reserved specifically for "Rare" or "Super Rare" designations and high-tier achievements.

## Typography

This design system employs a dual-font strategy to balance character with utility. **Montserrat** is used for headings to provide a bold, geometric, and authoritative voice. **Inter** is used for all body copy and UI labels to ensure perfect legibility at small sizes, especially when displaying card effects or complex deck lists.

Hierarchy is established through significant weight contrast. Titles should feel "heavy" and impactful, while data-heavy sections utilize Inter's clean, neutral shapes to keep the interface from feeling cluttered. All text is in Portuguese (Brazilian), ensuring that character names and card abilities are typeset with appropriate tracking for longer Romance-language strings.

## Layout & Spacing

The layout follows a **Fluid Grid** model based on a 4px baseline shift. For mobile screens, we utilize a 20px side margin to provide breathing room for the bold typography. 

- **Deck Grids:** Card galleries should use a 2-column layout on mobile, increasing to 4+ on tablet. Gutters between cards are kept at a tight 12px to maximize the card art visibility.
- **Information Density:** For "Deck List" views, vertical spacing is tightened to `8px` (sm) to allow users to see more of their deck without excessive scrolling.
- **Safe Areas:** Bottom navigation bars must respect device safe areas, with floating action buttons (FABs) for "Add Card" or "New Deck" positioned 24px from the bottom-right.

## Elevation & Depth

In the dark mode environment, depth is communicated through **Tonal Layering** supplemented by subtle **Ambient Shadows**. 

1. **Level 0 (Base):** Background (#0D0D0D).
2. **Level 1 (Cards/Items):** Surface (#1A1A1A) with a 1px border of #FFFFFF at 10% opacity.
3. **Level 2 (Modals/Pop-ups):** Surface (#262626) with a soft shadow (0px 8px 24px rgba(0,0,0,0.5)).

Shadows should be "clean"—meaning very low spread and high blur. Do not use colored shadows unless highlighting a "Winner" state or a "Legendary" card, where a subtle red or gold outer glow may be applied.

## Shapes

The design system utilizes **Rounded (0.5rem)** corners as the standard for all primary UI elements. This choice balances the "hard" competitive nature of the game with a modern, approachable feel.

- **Buttons & Input Fields:** 8px (0.5rem) corner radius.
- **Card Containers:** 16px (1rem) corner radius for large containers; 8px for mini-card thumbnails.
- **Selection Indicators:** Use pill-shapes (full rounding) for status chips (e.g., "Active," "Banned," "Resting").

## Components

### Buttons
- **Primary:** Background #E63946, Text #FFFFFF, 8px radius. Use Montserrat Bold for the label.
- **Secondary:** Transparent background, 1.5px border #FFFFFF, Text #FFFFFF.
- **Ghost:** No background or border, Montserrat Bold in Primary Red.

### Cards (TCG Specific)
- **Card Item:** Should feature the card image with an 8px radius. The "Cost" (number) should be in the top left inside a circular badge of Primary Red.
- **Attribute Chips:** Small, rounded-sm badges used for "Power," "Counter," and "Type" (Slash, Strike, etc.).

### Input Fields
- **Search Bar:** Dark background (#1A1A1A), 8px radius, placeholder text in Light Gray. Include a trailing "Filter" icon.
- **Checkboxes:** Square with 4px radius. When checked, fill with Primary Red and a white checkmark.

### Lists
- **Deck List Row:** High-density rows with a small card thumbnail, card name in Montserrat, and quantity (x4) in Primary Red. Use a 1px bottom border (#262626) to separate items.

### Floating Action Button (FAB)
- Circular button with a '+' icon, colored in Primary Red, elevated with a Level 2 shadow to indicate its primary importance for "New Deck" actions.
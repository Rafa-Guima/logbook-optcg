---
name: Crimson Clarity
colors:
  surface: '#f9f9f9'
  surface-dim: '#dadada'
  surface-bright: '#f9f9f9'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f3f3f3'
  surface-container: '#eeeeee'
  surface-container-high: '#e8e8e8'
  surface-container-highest: '#e2e2e2'
  on-surface: '#1a1c1c'
  on-surface-variant: '#5b403f'
  inverse-surface: '#2f3131'
  inverse-on-surface: '#f1f1f1'
  outline: '#8f6f6e'
  outline-variant: '#e4bebc'
  surface-tint: '#bb152c'
  primary: '#b7102a'
  on-primary: '#ffffff'
  primary-container: '#db313f'
  on-primary-container: '#fffbff'
  inverse-primary: '#ffb3b1'
  secondary: '#485f84'
  on-secondary: '#ffffff'
  secondary-container: '#bbd3fd'
  on-secondary-container: '#445a7f'
  tertiary: '#286182'
  on-tertiary: '#ffffff'
  tertiary-container: '#447a9c'
  on-tertiary-container: '#fcfcff'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#ffdad8'
  primary-fixed-dim: '#ffb3b1'
  on-primary-fixed: '#410007'
  on-primary-fixed-variant: '#92001c'
  secondary-fixed: '#d5e3ff'
  secondary-fixed-dim: '#b0c7f1'
  on-secondary-fixed: '#001b3c'
  on-secondary-fixed-variant: '#30476a'
  tertiary-fixed: '#c7e7ff'
  tertiary-fixed-dim: '#98cdf2'
  on-tertiary-fixed: '#001e2e'
  on-tertiary-fixed-variant: '#064c6b'
  background: '#f9f9f9'
  on-background: '#1a1c1c'
  surface-variant: '#e2e2e2'
typography:
  display-lg:
    fontFamily: Montserrat
    fontSize: 48px
    fontWeight: '700'
    lineHeight: 56px
    letterSpacing: -0.02em
  display-lg-mobile:
    fontFamily: Montserrat
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.01em
  headline-lg:
    fontFamily: Montserrat
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
  headline-md:
    fontFamily: Montserrat
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  body-lg:
    fontFamily: Montserrat
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Montserrat
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-md:
    fontFamily: Montserrat
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.01em
  label-sm:
    fontFamily: Montserrat
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.02em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 8px
  xs: 4px
  sm: 12px
  md: 24px
  lg: 48px
  xl: 80px
  container-max: 1280px
  gutter: 24px
  margin-mobile: 16px
---

## Brand & Style

This design system is built for high-impact clarity and energetic professionalism. It targets modern startups and consumer-facing platforms that require a balance of urgency and approachability. The brand personality is confident, direct, and vibrant, leveraging a high-contrast aesthetic to drive user action.

The design style is **Corporate / Modern** with a focus on **Minimalism**. It utilizes expansive white space, a restricted color palette, and precise geometric typography to ensure the interface feels intentional and organized. The emotional response should be one of reliability and momentum, achieved through the combination of a sharp primary red against a sterile, professional background.

## Colors

The palette is anchored by **Primary Red (#E63946)**, used specifically for calls-to-action, critical status indicators, and brand-defining accents. This is set against a purely white background to maximize brightness and perceived speed.

**Neutral Gray (#F5F5F5)** serves as the secondary surface color, providing subtle separation for containers, sidebars, and input fields without introducing visual clutter. Typography primarily uses a deep charcoal to maintain high legibility while appearing softer than pure black. Secondary and tertiary blues are reserved for supportive UI elements like informational badges or interactive links that shouldn't compete with the primary red.

## Typography

The design system utilizes **Montserrat** across all levels to maintain a cohesive, geometric, and modern identity. Headlines are set with tight letter-spacing and heavy weights to command attention. 

For body copy, the tracking is opened slightly to ensure readability. Mobile-specific overrides for display sizes are mandatory to prevent awkward text wrapping. Navigation and small labels utilize medium to semi-bold weights to remain distinct even at smaller scales. Use uppercase sparingly for labels to create a sense of hierarchy and structure.

## Layout & Spacing

The layout follows a **Fluid Grid** model based on an 8px base unit. For desktop, a 12-column grid with a maximum container width of 1280px ensures content remains digestible on ultra-wide monitors. 

- **Mobile:** 4-column grid with 16px side margins and 16px gutters.
- **Tablet:** 8-column grid with 24px side margins and 24px gutters.
- **Desktop:** 12-column grid with 24px gutters.

Vertical rhythm is maintained by using the `md` (24px) spacing for most component-to-component gaps, while `lg` (48px) is used to separate distinct sections of a page.

## Elevation & Depth

Visual hierarchy is established primarily through **Tonal Layers** and **Low-Contrast Outlines**. Instead of heavy shadows, the design system uses the contrast between `#FFFFFF` and `#F5F5F5` to indicate depth.

When an element must appear elevated (such as a modal or a floating menu), use a highly diffused, low-opacity shadow:
- **Shadow:** `0px 10px 30px rgba(0, 0, 0, 0.05)`
- **Border:** `1px solid rgba(0, 0, 0, 0.08)`

Cards and input fields should utilize the `#F5F5F5` background or a simple 1px stroke rather than elevation to maintain the clean, minimalist aesthetic.

## Shapes

The design system adopts a **Rounded** shape language to soften the impact of the bold red color and geometric typography. 

- **Standard Elements (Buttons, Inputs):** 0.5rem (8px) radius.
- **Large Elements (Cards, Modals):** 1rem (16px) radius.
- **Extra Large Elements (Promotional Banners):** 1.5rem (24px) radius.

This consistency in corner radius creates a friendly and approachable feel while maintaining the structural integrity of the layout.

## Components

### Buttons
- **Primary:** Background `#E63946`, Text `#FFFFFF`, 8px radius. Semi-bold Montserrat.
- **Secondary:** Background `#F5F5F5`, Text `#1D3557`, 8px radius. 
- **Ghost:** Transparent background, Border `1px solid #E63946`, Text `#E63946`.

### Input Fields
- **Default State:** Background `#F5F5F5`, Border `1px solid transparent`, 8px radius.
- **Focus State:** Background `#FFFFFF`, Border `2px solid #457B9D`.

### Cards
- Surfaces should be `#FFFFFF` with a subtle `1px solid #F5F5F5` border. Use `rounded-lg` for all container corners.

### Chips & Tags
- Compact height (32px), 100px radius (pill-shaped), using `label-sm` typography. 

### Progress Bars & Indicators
- Use the Primary Red for active progress against a `#F5F5F5` track to maintain high visibility and brand alignment.
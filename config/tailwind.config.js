// Source: https://github.com/bep/hugo-starter-tailwind-basic/blob/master/tailwind.config.js

module.exports = {
  darkMode: 'class',
	content: ['./hugo_stats.json'],
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
  ],
  theme: {
    extend: {
      typography: (theme) => ({
        DEFAULT: {
          css: {
            a: {
              fontWeight: theme('fontWeight.normal'),
              textDecoration: 'none', // Going to add "special-underline" instead
              // I don't think I can do anything equivalent to "@apply special-underline" here?
            },
          },
        },
      }),
    },
  },
}

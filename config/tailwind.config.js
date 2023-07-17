// Source: https://github.com/bep/hugo-starter-tailwind-basic/blob/master/tailwind.config.js

module.exports = {
  darkMode: 'class',
	content: ['./hugo_stats.json'],
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
  ],
}

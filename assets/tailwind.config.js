// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./js/**/*.js", "../lib/*_web.ex", "../lib/*_web/**/*.*ex"],
  theme: {
    fontSize: {
      md: ["1rem", "calc(var(--line-height) * 1)"],
      lg: ["2rem", "calc(var(--line-height) * 2)"],
      xl: ["3rem", "calc(var(--line-height) * 3)"],
    },
    spacing: {
      0: "0",
      1: "1ch",
      '1line': "calc(var(--line-height) * 1)",
      2: "2ch",
      '2lines': "calc(var(--line-height) * 2)",
      3: "3ch",
      '3lines': "calc(var(--line-height) * 3)",
      4: "4ch",
      '4lines': "calc(var(--line-height) * 4)",
      5: "5ch",
      '5lines': "calc(var(--line-height) * 5)",
    },
    media: {
      sm: "640px",
      md: "768px",
      lg: "1024px",
      xl: "1280px",
      '2xl': "1536px"
    }
  },
  plugins: [require("@tailwindcss/forms")],
};

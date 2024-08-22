// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./js/**/*.js", "../lib/*_web.ex", "../lib/*_web/**/*.*ex"],
  theme: {
    fontSize: {
      md: ["1rem", "1.2rem"],
      lg: ["2rem", "2.4rem"],
      xl: ["3rem", "3.6rem"],
    },
    spacing: {
      0: "0",
      1: "1ch",
      1.2: "1.2rem",
      2: "2ch",
      2.4: "2.4rem",
      3: "3ch",
      3.6: "3.6rem",
      4: "4ch",
      4.8: "4.8rem",
      5: "5ch",
      6: "rem",
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

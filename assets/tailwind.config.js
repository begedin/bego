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
      1: "1rem",
      1.2: "1.2rem",
      2: "2rem",
      2.4: "2.4rem",
      3: "3rem",
      3.6: "3.6rem",
      4: "4rem",
      4.8: "4.8rem",
      5: "5rem",
      6: "6rem",
    },
  },
  plugins: [require("@tailwindcss/forms")],
};

module.exports = {
  // The name of directory that contains your posts.
  blogPostDir: "posts",
  // The name of directory that contains your 'authors' folder.
  blogAuthorDir: "/",
  // The default and fallback author ID used for blog posts without a defined author.
  blogAuthorId: "begedin",
  siteTitle: "BEGO, IT Consulting, Nikola Begedin",
  // Alternative site title for SEO.
  siteTitleAlt: "BEGO, IT Consulting, Nikola Begedin",
  // Logo used for SEO and manifest. e.g. "/logos/logo-1024.png",
  // siteLogo: "",
  // Domain of your website without pathPrefix.
  siteUrl: "https://bego.hr",
  // Prefixes all links. For cases when deployed to example.github.io/gatsby-starter-casper/.
  // pathPrefix: "/",
  // Website description used for RSS feeds/meta description tag.
  siteDescription: "Technical articles, enterpreneurship tips, etc.",
  // Optional, the cover image used in header for home page. e.g: "/images/blog-cover.jpg",
  siteCover: "",
  // If navigation is enabled the Menu button will be visible
  siteNavigation: true,
  // Path to the RSS file.
  siteRss: "/rss.xml",
  // The author name used in the RSS file
  siteRssAuthor: "Nikola Begedib",
  // // optional, sets the FB Application ID for using app insights
  // siteFBAppID: "1825356251115265",
  // The max number of posts per page.
  sitePaginationLimit: 10,
  // GA tracking ID.
  // googleAnalyticsID: "UA-111982167-1",
  // enables Disqus comments, visually deviates from original Casper theme.
  // disqusShortname: "https-vagr9k-github-io-gatsby-advanced-starter",
  siteSocialUrls: [
    "https://github.com/begedin",
    "https://twitter.com/begedinnikola",
    "mailto:begedinnikola@gmail.com"
  ],
  // Default category for posts.
  postDefaultCategoryID: "Tech",
  // Links to social profiles/projects you want to display in the navigation bar.
  userLinks: [
    {
      label: "GitHub",
      url: "https://github.com/begedin",
      // Disabled, see Navigation.jsx
      iconClassName: "fa fa-github"
    },
    {
      label: "Twitter",
      url: "https://twitter.com/begedinnikola",
      // Disabled, see Navigation.jsx
      iconClassName: "fa fa-twitter"
    },
    {
      label: "Email",
      url: "mailto:begedinnikola@gmail.com",
      // Disabled, see Navigation.jsx
      iconClassName: "fa fa-envelope"
    }
  ],
  // Copyright string for the footer of the website and RSS feed.
  copyright: {
    // Label used before the year
    label: "Bego, IT Development and Consulting, owner Nikola Begedin"
    // optional, set specific copyright year or range of years, defaults to current year
    // year: "2018"
    // optional, set link address of copyright, defaults to site root
    // url: "https://www.gatsbyjs.org/"
  },
  // Used for setting manifest and progress theme colors.
  themeColor: "#c62828",
  // Used for setting manifest background color.
  backgroundColor: "#e0e0e0",
  // Enables the GatsbyJS promotion information in footer.
  promoteGatsby: true
};

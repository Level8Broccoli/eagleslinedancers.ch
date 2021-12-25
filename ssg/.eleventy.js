const MarkdownIt = require("markdown-it");
const Image = require("@11ty/eleventy-img");

module.exports = function (eleventyConfig) {
  eleventyConfig.addPassthroughCopy({ "styles/css/": "/styles/" });
  eleventyConfig.addPassthroughCopy({ "scripts/": "/scripts/" });
  eleventyConfig.addPassthroughCopy({ "public/": "/" });
  eleventyConfig.addFilter("markdownify", (content) => {
    const md = new MarkdownIt({
      html: true,
    });
    return md.render(content);
  });
  eleventyConfig.addNunjucksShortcode(
    "image",
    (src, alt, width, height, sizes = "100vw") => {
      let opts = {
        widths: [width],
        formats: ["jpeg"],
        outputDir: "./_site/img/",
      };
      Image(src, opts);
      let metadata = Image.statsByDimensionsSync(src, width, height, opts);
      let lowsrc = metadata.jpeg[0];
      let highsrc = metadata.jpeg[metadata.jpeg.length - 1];

      return `<picture>
      ${Object.values(metadata)
        .map((imageFormat) => {
          return `  <source type="${
            imageFormat[0].sourceType
          }" srcset="${imageFormat
            .map((entry) => entry.srcset)
            .join(", ")}" sizes="${sizes}">`;
        })
        .join("\n")}
        <img
          src="${lowsrc.url}"
          width="${highsrc.width}"
          height="${highsrc.height}"
          alt="${alt}"
          loading="lazy"
          decoding="async">
      </picture>`;
    }
  );
};

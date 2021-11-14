const MarkdownIt = require('markdown-it');

module.exports = function (eleventyConfig) {
    eleventyConfig.addPassthroughCopy({ 'styles/css/': "/styles/" })
    eleventyConfig.addPassthroughCopy({ 'scripts/': "/scripts/" })
    eleventyConfig.addPassthroughCopy({ 'public/': "/" })
    eleventyConfig.addFilter('markdownify', (content) => {
        const md = new MarkdownIt({
            html: true
        });
        return md.render(content);
    });
}

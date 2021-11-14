const fussnavigation = require("./fussnavigation.json");
const hauptnavigation = require("./hauptnavigation.json");

module.exports = () => {
    const mainNavigation = hauptnavigation.Navigationspunkte
        .map(item => {
            if (item.__component === "navigation.seiten") {
                item.Seiten = item.Seiten.filter(subItem => {
                    return ("Permalink" in subItem.Seite);
                });
            }
            return item;
        })
        .filter(item => {
            if (item.__component === "navigation.seite") {
                return "Permalink" in item.Seite;
            } else if (item.__component === "navigation.seiten") {
                return item.Seiten.length > 0;
            }
            return true;
        });
    const secondNavigation = fussnavigation.Navigationspunkte
        .filter(item => {
            if (item.__component === "navigation.seite") {
                return "Permalink" in item.Seite;
            }
            return true;
        });

    return {
        mainNavigation,
        secondNavigation,
    }
}

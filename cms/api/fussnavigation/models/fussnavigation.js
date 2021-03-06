'use strict';

/**
 * Read the documentation (https://strapi.io/documentation/developer-docs/latest/development/backend-customization.html#lifecycle-hooks)
 * to customize this model
 */

module.exports = {
    lifecycles: {
        async afterCreate() {
            strapi.config.functions['cd']();
        },
        async afterUpdate() {
            strapi.config.functions['cd']();
        },
        async afterDelete() {
            strapi.config.functions['cd']();
        },
    },
};

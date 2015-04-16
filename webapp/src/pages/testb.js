Qmik.define(function(require, exports, module) {
    var View = Backbone.View.extend({

        tagName: "li",

        className: "document-row",

        events: {
            "click .icon": "open",
            "click .button.edit": "openEditDialog",
            "click .button.delete": "destroy"
        },

        initialize: function() {
            // this.listenTo(this.model, "change", this.render);
        },

        render: function() {
            this.$el.text('test1 works');
        }

    });

    module.exports = View;
});
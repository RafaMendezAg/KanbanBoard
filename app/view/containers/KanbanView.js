Ext.define('App.view.containers.KanbanView', {
    extend: 'Ext.panel.Panel',
    xtype: 'kanban-view',

    title: 'Kanban',

    requires: [
        'App.ux.kanban.KanbanBoard',
        'App.store.KanbanStore'
    ],

    layout: {
        type: 'fit',
    },
    items: [{
        xtype: 'kanban-board',
        store: { type: 'kanban-store' },
        columns: [{
            title: 'Identified',
            columnId: 1,
            color: 'gray'
        }, {
            title: 'Interview',
            columnId: 2,
            color: 'yellow'
        }, {
            title: 'Accepted',
            columnId: 3,
            color: 'blue'
        }, {
            title: 'Hired',
            columnId: 4,
            color: 'green'
        }]
    }],

});
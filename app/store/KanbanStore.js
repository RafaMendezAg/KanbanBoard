Ext.define('App.store.KanbanStore', {
    extend: 'Ext.data.Store',
    alias: 'store.kanban-store',

    autoLoad: true,
    remoteSort: true,
    remoteFilter: true,

    columnId: 0,

    listeners:{
        beforeload: function(store){
            store.getProxy().setExtraParams({columnId: this.columnId});
        }
    },

    proxy:{
        type:'rest',
        url:'/backend/handlers/kanban',
        reader:{
            type:'json',
            rootProperty:'data',
            idProperty:'id',
            totalProperty: 'total'
        }
    }


});
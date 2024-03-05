Ext.define('App.ux.kanban.KanbanBoard', {
    extend: 'Ext.panel.Panel',
    xtype: 'kanban-board',

    scrollable: 'horizontal',

    requires:[
        'App.ux.kanban.KanbanColumn'

    ],

    config:{
        store: null,
        columns:[]

    },

    layout:{
        type:'hbox',
        align:'stretch'
    },

    defaults:{
        flex:1,
    },

    cls:'board-container',

    items:[],

    initComponent: function(){
        let me=this;
        this.callParent();

        if(me.store!==null && me.columns!==null && me.columns.length > 0){
            for(let i=0; i<me.columns.length; i++){
                let columnData = me.columns[i];
                let column = Ext.create('App.ux.kanban.KanbanColumn',{
                    title: columnData.title || 'Column '+i,
                    store: me.store,
                    columnId: columnData.columnId,
                    userCls: 'board-column-title-'+(columnData.color || 'black' ),
                });
                me.add(column);
            }
        }
        
        
    }



});
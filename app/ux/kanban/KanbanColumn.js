Ext.define('App.ux.kanban.KanbanColumn', {
    extend: 'Ext.panel.Panel',
    xtype: 'kanban-column',

    layout:'fit',
    cls: 'board-column-container',

    config:{
        store:null,
        columnId: 0
    },

    items:[{
        xtype:'dataview',
        itemSelector: 'div.task-selector',
        tpl:[
            '<tpl for=".">', 
            '<div class="task-selector">', 
                '<div class="title">{title}</div>',
                '<div class="content">',
                    '<div class="icon"><span class="fa fa-{icon}"></span></div>',
                    '<div class="text">{content}</div>',
                '</div>', 
            '</div>', 
        '</tpl>'
        ],

        listeners:{
            render: function(me){
                //Start of the drag
                    me.dragZone = new Ext.dd.DragZone(me.getEl(),{
                        getDragData: function (e) {
                            let ElBase = e.getTarget(me.itemSelector, 10);
                            if (ElBase) {
                                let duplicate = ElBase.cloneNode(true);
                                duplicate.id = Ext.id();
                                return {
                                    ddel: duplicate,
                                    sourceEl: ElBase,
                                    sourceZone: me,
                                    sourceStore: me.store,
                                    repairXY: Ext.fly(ElBase).getXY(),
                                    draggedRecord: me.getRecord(ElBase)
                                }
                            }
                        },

                        getRepairXY: function(){
                           return this.dragData.repairXY;
                        }
                    });
                // End of Drag
                    me.dropZone = new Ext.dd.DropZone(me.getEl(),{
                        allowDrop: function(allowed){
                            return allowed ? Ext.dd.DropZone.prototype.dropAllowed : Ext.dd.DropZone.prototype.dropNotAllowed;
                        },
                        
                        notifyOver: function(source){
                            return this.allowDrop(source !== me.dragZone);
                        },

                        onContainerDrop: function(source){
                            if(source == me.dragZone) {
                                return false;
                            }

                            let rec = source.dragData.draggedRecord;
                            source.dragData.sourceStore.remove(rec);
                            me.getStore().add(rec);
                        }
                    });
            }
        }
    }],

    initComponent: function(){
       let me=this;
       if (me.store!==null){
            me.items[0].store = Ext.apply(me.store, {columnId: me.columnId});
       }
      
       me.callParent();
    }
   
});
({
    init: function (cmp, event, helper) {
        // create a one-time use instance of the serverEcho action
        // in the server-side controller
        var action = cmp.get("c.fetchData");
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // Alert the user with the value returned 
                // from the server
                console.log("From server: " + response.getReturnValue()[0].Title + " " + response.getReturnValue()[0].Url);
                cmp.set('v.data', response.getReturnValue());
                cmp.set('v.items', response.getReturnValue());
                // You would typically fire a event here to trigger 
                // client-side notification that the server-side 
                // action is complete
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });

        // optionally set storable, abortable, background flag here

        // A client-side action could cause multiple events, 
        // which could trigger other events and 
        // other server-side action calls.
        // $A.enqueueAction adds the server-side action to the queue.
        $A.enqueueAction(action);
    },

    filter: function (cmp, event, helper) {
        let allData = cmp.get('v.data');
        let filterBy = cmp.get('v.input');
        console.log(filterBy);
        let newItems =[];
        if(!!filterBy){
            for(let row of allData)
            {
                if(row.Title.includes(filterBy)){
                    newItems.push(row);
                    console.log(row);
                }
            }
        } else {
            newItems = allData;
        }
        cmp.set('v.items', newItems);
    },

    save: function (cmp, event, helper) {
        //saves list
        var action = cmp.get("c.sendEmail");
        action.setParams({
            'images': JSON.stringify(cmp.get('v.items')),
            'email': cmp.get('v.email')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("From server: " + response.getReturnValue());
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    }
});
jQuery.fn.dataTableExt.oSort['html-numeric-asc'] = function(a, b) {
    var x = a.replace(/<.*?>/g, "") * 1;
    var y = b.replace(/<.*?>/g, "") * 1;
    return ((x < y) ? -1 : ((x > y) ? 1 : 0));
};

jQuery.fn.dataTableExt.oSort['html-numeric-desc'] = function(a, b) {
    var x = a.replace(/<.*?>/g, "") * 1;
    var y = b.replace(/<.*?>/g, "") * 1;
    return ((x < y) ? 1 : ((x > y) ? -1 : 0));
};

$(document).ready(function() {
    $('#noteTable').dataTable({
        "bPaginate": false,
        "bInfo": false,
        "oLanguage": {
            "sSearch": "S&oslash;k:",
            "sZeroRecords": "Ingen treff"
        },
        "aoColumns": [
            {
                "sType": "html-numeric"
            },
            {
                "sType": "html"
            },
            null,
            null,
            null,
            {
                "bSortable": false
            },
            null,
            {
                "bSearchable": false
            }
        ],
        "aaSorting": [
            [1,'asc']
        ]
    });

    $('#evensongTable').dataTable({
        "bPaginate": false,
        "bInfo": false,
        "oLanguage": {
            "sSearch": "S&oslash;k:",
            "sZeroRecords": "Ingen treff"
        },
        "aoColumns": [
            {
                "sType": "html"
            },
            null,
            null,
            null,
            {
                "bSearchable": false
            }
        ]
    });
    
    $('#userTable').dataTable({
        "bPaginate": false,
        "bInfo": false,
        "oLanguage": {
            "sSearch": "S&oslash;k:",
            "sZeroRecords": "Ingen treff"
        },
        "aaSorting": [
            [1,'asc']
        ]
    });
});

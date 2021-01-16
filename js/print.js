document.getElementById('printMe').addEventListener('click', printDiv)

function printDiv() {
    var divToPrint = document.getElementById('printData');
    var htmlToPrint =
        `<style type="text/css"> 

            * {
                box-sizing: border-box;
                text-align: left;
                font-family: monospace;
                font-size: 12pt;
                color: rgb(16,16,16);
                
            }

            #myTable {
                background-color: transparent;
                width: 100%;
                display: table;
                box-sizing: border-box;
                text-align: start !important;
                // border-color: grey;
                // font-variant: normal;
                // border: 0.1px solid #000;
                border-collapse: collapse;
            }

            th, td {
                text-align: start !important;
            }

            thead {
                display: table-header-group;
                vertical-align: middle;
                border-color: inherit;
                // border: 0.1px #bbb solid;
            }

            th {
                display: table-cell;
                font-weight: 600;
                border-color: #32383e;
                vertical-align: bottom;
                padding: .3rem;
                // border: 0.1px #e9ecef solid;
                // font-size: 13px;
                font-size: 12pt;
            }

            td {
                display: table-cell;
                // border: solid 0.1px #e9ecef !important;
                border-bottom: none;
                border-collapse: collapse;
                // font-size: 12px;
                padding: .3rem;
                font-size: 12pt;
                white-space: nowrap;
            }

            a.text-info,
            a.text-info:hover {
                text-decoration: none !important;
                color: #000 !important;
                // font-size: 12px;
            }

            @page {
                margin: 2cm;
            }

            #printData {
                /* columns: 7; */
                /* orphans: 3; */
            }

            .currency-sign {
                // color: #393e46 !important;
                // font-size: 11pt;
            }
            

            @page :first {
                margin-top: 2.5cm;
            }

            header, footer, aside, nav, form, iframe, .menu, .hero, .adslot {
                display: none;
            }
            
            .totalAmount {
                // text-decoration: underline;
                // text-underline-position: under;
                border-top: 1px solid #252422 !important;
                border-bottom: 1px solid #252422 !important;
                font-size: 12pt;
            }

            .totalAmountManyCollect {
                border-top: 1px solid #252422 !important;
                border-bottom: 1px solid #252422 !important;
                font-weight: 500 !important;
                font-size: 12pt;
            }

            .totalAmountCollect {
                // border-top: 1px solid #252422 !important;
                // border-bottom: 1px solid #252422 !important;
                font-weight: 500 !important;
                font-size: 12pt;
            }

            .blank_row {
                display: table-cell !important;
                padding: .3rem !important;
                height: 30px;
            }

            td.bold-text {
                font-weight: 600 !important;
            }

            .heading-print {
                display: block !important;
                font-weight: 600;
                margin-bottom: 1cm;
                // font-size: 16px;
            }

            .date-range-print {
                font-weight: 400;
                font-family: Cambria, Cochin, Georgia, Times, 'Times New Roman', serif;
                display: inline-block;
                // font-size: 13px;
            }

            // #printData::after {
            //     content: 'JollyChef Inc.';
            //     display: block;
            //     text-align: center;
            //     padding: 50px;
            // }

            .print-main-heading, .print-heading-company, .print-heading-company + p {
                text-align: center !important;
            }

            .final-total {
                font-weight: 600;
                font-size: 13pt;
                border-top: #000 1px solid !important;
                border-bottom: #000 1px solid !important;
            }

            .total-label, .name-label {
                font-weight: 600;
            }

        </style>`

    htmlToPrint += divToPrint.outerHTML;
    newWin = window.open("");
    newWin.document.write(htmlToPrint);
    newWin.print();
    newWin.close();

}
    // $("#myTable").print({
    //     	globalStyles: true,
    //     	mediaPrint: false,
    //     	stylesheet: null,
    //     	noPrintSelector: ".no-print",
    //     	iframe: true,
    //     	append: null,
    //     	prepend: null,
    //     	manuallyCopyFormValues: true,
    //     	deferred: $.Deferred(),
    //     	timeout: 750,
    //     	title: null,
    //     	doctype: '<!doctype html>'
	// });

    // $("#myTable").find('.printMe').on('click', function() {
    //     console.log('Print');
    //     $.print("#myTable");
    // });




// function printData() {
//     // $("#myTable").find('.print').on('click', function() {
//     //     $.print("#printable");
//     // });
    
// }


//    var divToPrint=document.getElementById("myTable");
//    newWin= window.open("");
//    newWin.document.write(divToPrint.outerHTML);
//    newWin.print();
//    newWin.close();
// }

// document.getElementById('printMe').addEventListener('click', () => {
//     $("#printData").print({
//         globalStyles: true,
//         mediaPrint: false,
//         stylesheet: null,
//         noPrintSelector: ".no-print",
//         iframe: true,
//         append: null,
//         prepend: null,
//         manuallyCopyFormValues: true,
//         deferred: $.Deferred(),
//         timeout: 750,
//         title: null,
//         doctype: '<!doctype html>'
// 	});
// })
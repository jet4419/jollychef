var mini = true;

    function toggleSidebar() {
        if (mini) {
            //console.log("opening sidebar");
            document.getElementById("mySidebar").style.width = "280px";
            document.getElementById("main").style.marginLeft = "280px";

            if (document.querySelector(".footer"))
                document.querySelector(".footer").style.marginLeft = "280px";
            this.mini = false;
        } else {
            //console.log("closing sidebar");
            document.getElementById("mySidebar").style.width = "50px";
            document.getElementById("main").style.marginLeft = "0";

            if (document.querySelector(".footer"))
                document.querySelector(".footer").style.marginLeft = "0";
            // document.querySelector(".checkbox").checked = false;
            this.mini = true;
        }
    }
// let mini = true;
// let mySidebar = document.getElementById('mySidebar');

// mySidebar.addEventListener('mouseover', toggleSidebar);
// mySidebar.addEventListener('mouseout', toggleSidebar);

//     function toggleSidebar() {
//         if (mini) {
//             //console.log("opening sidebar");
//             document.getElementById("mySidebar").style.width = "280px";
//             document.getElementById("main").style.marginLeft = "280px";

//             if (document.querySelector(".footer"))
//                 document.querySelector(".footer").style.marginLeft = "280px";

//             mini = false;
//         } else {
//             //console.log("closing sidebar");
//             document.getElementById("mySidebar").style.width = "50px";
//             document.getElementById("main").style.marginLeft = "50px";

//             if (document.querySelector(".footer"))
//                 document.querySelector(".footer").style.marginLeft = "0";
//             // document.querySelector(".checkbox").checked = false;
//             mini = true;
//         }
//     }

const mySidebar = document.getElementById('mySidebar');

if (mySidebar) {
  mySidebar.addEventListener('mouseover', toggleSidebar);
  mySidebar.addEventListener('mouseout', unToggleSidebar);
}

const mainElement = document.getElementById('main');
const footerElement = document.querySelector('.footer');

const line1 = document.querySelector('.line-1');
const line2 = document.querySelector('.line-2');
const line3 = document.querySelector('.line-3');

const btnNav = document.getElementById('btn-collapsible-bar');

if (btnNav) {
  btnNav.addEventListener('click', () => {
    line1.classList.toggle('line-1-anim');
    line2.classList.toggle('line-2-anim');
    line3.classList.toggle('line-3-anim');
  
    mySidebar.classList.toggle('scale-up-width');
    mainElement.classList.toggle('scale-up-margin');
  
    if (footerElement) {
      footerElement.classList.toggle('scale-up-margin');
    }
  });
}

function toggleSidebar() {

  line1.classList.add('line-1-anim');
  line2.classList.add('line-2-anim');
  line3.classList.add('line-3-anim');

  mySidebar.classList.add('scale-up-width');
  mainElement.classList.add('scale-up-margin');

  if (footerElement) {
    footerElement.classList.add('scale-up-margin');
  }
}

function unToggleSidebar() {

  line1.classList.remove('line-1-anim');
  line2.classList.remove('line-2-anim');
  line3.classList.remove('line-3-anim');

  mySidebar.classList.remove('scale-up-width');
  mainElement.classList.remove('scale-up-margin');

  if (footerElement) {
    footerElement.classList.remove('scale-up-margin');
  }
}

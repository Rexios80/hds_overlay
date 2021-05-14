function hideSplash() {
    const splash = document.getElementById("splash");
    splash.style.display = "none";

    const htmlTags = document.getElementsByTagName("html");
    for (let i = 0; i < htmlTags.length; i++) {
        htmlTags[i].style.background = "#00000000";
    }

    document.body.style.background = "#00000000";
}
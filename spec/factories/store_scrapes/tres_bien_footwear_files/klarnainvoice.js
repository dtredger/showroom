function addKlarnaInvoiceEvent(a){window.attachEvent?this.attachEvent("onload",a):this.addEventListener("load",a,!1)}function ShowKlarnaInvoicePopup(){var a=self.pageYOffset||document.body.scrollTop||document.documentElement.scrollTop,b=a+50;document.getElementById("klarna_invoice_popup").style.top=b+"px",klarnainvoicelang=="se"?document.getElementById("iframe_klarna_invoice").src="https://online.klarna.com/villkor.yaws?eid="+klarnainvoiceeid+"&charge="+klarnainvoiceefee:document.getElementById("iframe_klarna_invoice").src="https://online.klarna.com/villkor_"+klarnainvoicelang+".yaws?eid="+klarnainvoiceeid+"&charge="+klarnainvoiceefee,document.getElementById("klarna_invoice_popup").style.display="block"}function InitKlarnaInvoiceElements(a,b,c,d){if(document.getElementById(a)!=null){klarnainvoicelang=c,klarnainvoiceeid=b,d?klarnainvoiceefee=d:klarnainvoiceefee=0;var e="Villkor f&ouml;r faktura",f="St&auml;ng",g="500px",h="630px";switch(klarnainvoicelang){case"se":case"swe":e="Villkor f&ouml;r faktura",f="St&auml;ng",klarnainvoicelang="se",g="500px",h="510px";break;case"dk":case"dnk":f="Luk vindue",e="Vilk&aring;r for faktura",klarnainvoicelang="dk",g="500px",h="490px";break;case"no":case"nok":case"nor":e="Vilk&aring;r for faktura",f="Lukk",klarnainvoicelang="no",g="500px",h="490px";break;case"fi":case"fin":e="Laskuehdot",f="Sulje",klarnainvoicelang="fi",g="500px",h="500px";break;case"de":case"deu":e="Rechnungsbedingungen",f="Schliessen",klarnainvoicelang="de",g="500px",h="570px";break;case"nl":case"nld":e="Factuurvoorwaarden",f="Sluit",klarnainvoicelang="nl",g="500px",h="510px"}document.getElementById(a).innerHTML=e;var i=document.createElement("div");i.id="klarna_invoice_popup",i.style.display="none",i.style.backgroundColor="#ffffff",i.style.border="solid 1px black",i.style.width=g,i.style.position="absolute",i.style.left=document.documentElement.offsetWidth/2-250+"px",i.style.top="50px",i.style.zIndex=9999,i.style.padding="10px";var j=document.createElement("iframe");j.id="iframe_klarna_invoice",j.frameBorder=0,j.style.border=0,j.style.width=g,j.style.height=h,i.appendChild(j);var k=document.createElement("a");k.href="#",k.style.color="#000000",k.onclick=function(){document.getElementById("klarna_invoice_popup").style.display="none";return!1},k.innerHTML=f,i.appendChild(k),document.body.insertBefore(i,null)}}var klarnainvoicelang="",klarnainvoiceeid=0,klarnainvoiceefee=0
if(!self.define){let s,e={};const i=(i,n)=>(i=new URL(i+".js",n).href,e[i]||new Promise((e=>{if("document"in self){const s=document.createElement("script");s.src=i,s.onload=e,document.head.appendChild(s)}else s=i,importScripts(i),e()})).then((()=>{let s=e[i];if(!s)throw new Error(`Module ${i} didn’t register its module`);return s})));self.define=(n,r)=>{const l=s||("document"in self?document.currentScript.src:"")||location.href;if(e[l])return;let o={};const t=s=>i(s,l),u={module:{uri:l},exports:o,require:t};e[l]=Promise.all(n.map((s=>u[s]||t(s)))).then((s=>(r(...s),o)))}}define(["./workbox-f3e6b16a"],(function(s){"use strict";self.skipWaiting(),s.clientsClaim(),s.precacheAndRoute([{url:"assets/Config-DNdP15iQ.js",revision:null},{url:"assets/ConfigTitle-C0Nf-ceG.js",revision:null},{url:"assets/Connections-aoyMxjE7.js",revision:null},{url:"assets/global-Dt3RF34O.js",revision:null},{url:"assets/index-BISvbaWk.js",revision:null},{url:"assets/index-BWze4VzI.js",revision:null},{url:"assets/index-kvdBXnZn.css",revision:null},{url:"assets/Logs-DDZTaMEd.js",revision:null},{url:"assets/Overview-Cip196yb.js",revision:null},{url:"assets/Proxies-D8925CDW.js",revision:null},{url:"assets/Rules-Dl1cEItO.js",revision:null},{url:"assets/Setup-C73I4rRH.js",revision:null},{url:"assets/vendor-6rLqdkxq.js",revision:null},{url:"index.html",revision:"ab6d4fd39d43e96fd4e6a0ee12c009b4"},{url:"registerSW.js",revision:"402b66900e731ca748771b6fc5e7a068"},{url:"favicon.svg",revision:"f5b3372f312fbbe60a6ed8c03741ff80"},{url:"pwa-192x192.png",revision:"c45f48fc59b5bf47e6cbf1626aff51fc"},{url:"pwa-512x512.png",revision:"a311504ae6a46bd29b5678a410aaafc6"},{url:"manifest.webmanifest",revision:"4d78c8bc6207146065400ff644fe5a13"}],{}),s.cleanupOutdatedCaches(),s.registerRoute(new s.NavigationRoute(s.createHandlerBoundToURL("index.html")))}));

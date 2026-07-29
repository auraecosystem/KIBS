(() => {
“use strict”;

const config = window.KIBS_CONFIG || {};

async function getStatus() {
const response = await fetch(${config.api}/status);

if (!response.ok) {
  throw new Error("KIBS API unavailable");
}
return response.json();

}

async function initializeKIBS() {
const statusElement = document.getElementById(“kibs-status”);

try {
  const status = await getStatus();
  statusElement.innerHTML = `
    <p>
      KIBS Runtime:
      <strong>${status.status}</strong>
    </p>
  `;
} catch (error) {
  statusElement.innerHTML = `
    <p>
      KIBS Runtime:
      <strong>Offline</strong>
    </p>
  `;
  console.error("KIBS initialization failed:", error);
}

}

document.addEventListener(“DOMContentLoaded”, initializeKIBS);
})();

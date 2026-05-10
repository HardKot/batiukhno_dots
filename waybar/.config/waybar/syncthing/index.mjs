const SYNCTHING_API_URL = "http://localhost:8384/rest/system/status";
const SYNCTHING_API_KEY = "asNVRpKeVMmxJSXG9E7yKT5qbzMLKFUM";
const SYNCTHING_CLASS = "syncthing";

async function main() {
  const response = await fetch(SYNCTHING_API_URL, {
    headers: {
      "X-API-Key": SYNCTHING_API_KEY,
    },
  });

  if (!response.ok) {
    console.log(
      JSON.stringify({
        error: "",
        class: "error",
        alt: "error",
      }),
    );
    return;
  }

  const { uptime } = await response.json();

  if (uptime) {
    console.log(
      JSON.stringify({
        text: `Syncthing: ${uptime}s`,
        class: SYNCTHING_CLASS,
        alt: "success",
      }),
    );
  } else {
    console.log(
      JSON.stringify({
        text: `Syncthing: Ok`,
        class: SYNCTHING_CLASS,
        alt: "success",
      }),
    );
  }
}

main();

import { group, check, sleep } from "k6";
import { Counter, Rate } from "k6/metrics";
import http from "k6/http";

export let options = {
	vus: 5,
	thresholds: {
		my_rate: ["rate>=0.4"], // Require my_rate's success rate to be >=40%
		http_req_duration: ["avg<1000"], // Require http_req_duration's average to be <1000ms
	},
    stages: [
        // Ramp-up from 1 to 5 VUs in 10s
        { duration: "40s", target: 5 },

        // Stay at rest on 5 VUs for 5s
        { duration: "5s", target: 5 },

        // Ramp-down from 5 to 0 VUs for 5s
        { duration: "5s", target: 0 }
    ]
};



let mCounter = new Counter("my_counter");
let mRate = new Rate("my_rate");

export default function() {

    check(http.get("http://localhost:8080/gitops-hugo-bg"), {
        "status is 200": (r) => r.status == 200,
        // "protocol is HTTP/2": (r) => r.proto == "HTTP/2.0",
      });
};
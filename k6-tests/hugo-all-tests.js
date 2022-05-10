import { group, check, sleep } from "k6";
import { Counter, Rate } from "k6/metrics";
import http from "k6/http";

var functionalTests = [
    require("./hugo-bg-smoke-preview.js").default,
    require("./hugo-bg-smoke.js").default,
    // ...
];
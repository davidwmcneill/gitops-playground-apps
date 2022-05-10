import http from 'k6/http';
import { check, group, sleep, fail } from 'k6';

export const options = {
  vus: 3, // 3 user looping for 60 minute
  duration: '60m',

  thresholds: {
    http_req_duration: ['p(99)<1500'], // 99% of requests must complete below 1.5s
  },
};

const BASE_URL = 'http://localhost:8080/gitops-hugo-bg';

export default () => {
    check(http.get(`${BASE_URL}`), {
        "status is 200": (r) => r.status == 200,
        // "protocol is HTTP/2": (r) => r.proto == "HTTP/2.0",
      });

  sleep(1);
};

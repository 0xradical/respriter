import { pgrestApi, railsApi, crossOriginXHR } from "./axiosFactory";
import icpt from "./axiosInterceptors";

// pgrestApi interceptors mixin
pgrestApi.interceptors.request.use(icpt.req.suc, icpt.req.err);
pgrestApi.interceptors.response.use(icpt.res.suc, icpt.res.err);

// railsApi interceptors mixin
railsApi.interceptors.request.use(icpt.req.suc, icpt.req.err);
railsApi.interceptors.response.use(icpt.res.suc, icpt.res.err);

export { pgrestApi, railsApi, crossOriginXHR };

import http from "../http-common";

class CustomerDataService {
  getAll(params) {
    return http.get("/customers", { params });
  }

  get(id) {
    return http.get(`/customers/${id}`);
  }
}

export default new CustomerDataService();

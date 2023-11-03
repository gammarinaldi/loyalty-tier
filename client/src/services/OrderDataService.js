import http from "../http-common";

class OrderDataService {
  getAll(params) {
    return http.get("/completed_orders", { params });
  }

  get(id) {
    return http.get(`/completed_orders/${id}`);
  }
}

export default new OrderDataService();

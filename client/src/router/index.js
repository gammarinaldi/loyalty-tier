import { createRouter, createWebHistory } from "vue-router";
import CustomersView from "../views/CustomersView.vue";
import OrdersView from "../views/OrdersView.vue";

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: "/",
      name: "customers",
      component: CustomersView,
    },
    {
      path: "/orders",
      name: "orders",
      component: OrdersView,
    },
  ],
});

export default router;

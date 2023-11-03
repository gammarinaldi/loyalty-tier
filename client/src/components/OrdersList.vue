<template>
  <div class="container">
    <h2>Orders List</h2>
    <br/>
    <!-- Orders list-->
    <div>
      <table class="orders-table">
        <thead>
          <tr>
            <th>Order ID</th>
            <th>Customer Name</th>
            <th>Order Date</th>
            <th>Total Spent</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(order, index) in orders" 
            :key="index" 
            :class="{ 'highlight-row': index % 2 === 0 }"
            @mouseout="removeHighlight"
          >
            <td>{{ order.orderId }}</td>
            <td>{{ order.customerName }}</td>
            <td>{{ order.date }}</td>
            <td>$ {{ (order.totalInCents / 100).toFixed(2) }}</td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Pagination -->
    <Pagination 
      :total-items="totalItems" 
      :items-per-page="itemsPerPage" 
      @page-change="handlePageChange" 
    />

  </div>
</template>

<script>
import OrderDataService from "../services/OrderDataService";
import Pagination from "./Pagination.vue";

export default {
  name: "orders-list",
  components: {
    Pagination,
  },
  data() {
    return {
      orders: [],
      currentOrder: false,
      order: {},
      currentIndex: -1,
      totalItems: 0,
      itemsPerPage: 5,
      currentPage: 1
    };
  },
  methods: {
    getRequestParams(page) {
      let params = {};

      if (page) {
        params["page"] = page;
      }

      return params;
    },

    retrieveOrders() {
      const params = this.getRequestParams(this.page);

      OrderDataService.getAll(params)
        .then((response) => {
          // console.log(response.data);

          const { data, metadata } = response.data;
  
          this.orders = data
          this.totalItems = metadata.totalItems
        })
        .catch((e) => {
          console.log(e);
        });
    },

    retrieveOrderDetail(id) {
      OrderDataService.get(id)
        .then((response) => {
          // console.log(response.data);

          const { data } = response.data;
          this.order = data
        })
        .catch((e) => {
          console.log(e);
        });
    },

    handlePageChange(value) {
      this.page = value;
      this.retrieveOrders();
    },

    refreshList() {
      this.retrieveOrders();
      this.currentOrder = null;
      this.currentIndex = -1;
    },

    setActiveOrder(id, index) {
      this.retrieveOrderDetail(id);
      this.currentOrder = true;
      this.currentIndex = index;
    },
  },
  mounted() {
    this.retrieveOrders();
  },

};
</script>

<style>
.orders-table {
  width: 100%;
  border-collapse: collapse;
}

.orders-table th, .orders-table td {
  border: 1px solid #ccc;
  padding: 10px;
  text-align: left;
}

.orders-table tbody tr:hover {
  background-color: #fadb66;
}

.orders-table tbody tr.highlighted {
  background-color: #ffffcc;
}

.highlight-row {
  background-color: #e6f7ff; /* or any other highlight color of your choice */
}
</style>

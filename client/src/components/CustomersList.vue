<template>
  <div class="container">
    <!-- Customers list-->
    <div>
      <h2>Customers List</h2>
      <br/>
      <ul class="list-group" id="customers-list">
        <li
          class="list-group-item"
          v-for="(customer, index) in customers"
          :key="index"
          @click="setActiveCustomer(customer.customerId, index)"
        >
          {{ customer.customerName }}
        </li>
      </ul>

      <!-- Pagination -->
      <Pagination 
        :total-items="totalItems" 
        :items-per-page="itemsPerPage" 
        @page-change="handlePageChange" 
      />
    </div>

    <div style="width: 500px; margin-top:30px; margin-bottom:30px;">
      <hr style="border-top: 3px dotted #bbb;">
    </div>

    <!-- Customer detail -->
    <div>
      <div v-if="currentCustomer">
        <div><h3>{{ customer.customerName }}</h3></div>

        <!-- Progress bar -->
        <div class="progress" style="margin-top: 10px;">
          <div class="progress-bar" role="progressbar" :style="{ width: progress + '%' }" :aria-valuenow="progress" aria-valuemin="0" aria-valuemax="100">
            {{ progressText }}
          </div>
        </div>
        
        <table class="custom-table">
          <tr>
            <td><strong>Current tier:</strong></td>
            <td>{{ customer.currentTier }}</td>
          </tr>
          <tr>
            <td><strong>Start date of tier calculation:</strong></td>
            <td>{{ customer.startDateTierCalculation }}</td>
          </tr>
          <tr>
            <td><strong>Amount spent since start date:</strong></td>
            <td>$ {{ (customer.amountSpentSinceStartDate / 100).toFixed(2) }}</td>
          </tr>
          <tr>
            <td><strong>Remaining amount to maintain tier:</strong></td>
            <td>$ {{ (customer.amountToMaintainTier / 100).toFixed(2) }}</td>
          </tr>
          <tr>
            <td><strong>Tier if downgraded:</strong></td>
            <td>
              <span v-if="customer.nextYearDowngradeTier !== null">{{ customer.nextYearDowngradeTier }}</span>
              <span v-else>-</span>
            </td>
          </tr>
          <tr>
            <td><strong>Remaining amount to next tier:</strong></td>
            <td>$ {{ (customer.amountToNextTier / 100).toFixed(2) }}</td>
          </tr>
        </table>

      </div>
      <div v-else>
        <p>Please click on a customer name for details.</p>
      </div>
    </div>
  </div>
</template>

<script>
import CustomerDataService from "../services/CustomerDataService";
import Pagination from "./Pagination.vue";

export default {
  name: "customers-list",
  components: {
    Pagination,
  },
  data() {
    return {
      customers: [],
      currentCustomer: false,
      customer: {},
      currentIndex: -1,
      totalItems: 30,
      itemsPerPage: 5,
      currentPage: 1,
      progress: 0,
      progressText: ""
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

    retrieveCustomers() {
      const params = this.getRequestParams(this.page);

      CustomerDataService.getAll(params)
        .then((response) => {
          // console.log(response.data);

          const { data, metadata } = response.data;

          this.customers = data
          this.count = metadata.totalItems
        })
        .catch((e) => {
          console.log(e);
        });
    },

    retrieveCustomerDetail(id) {
      CustomerDataService.get(id)
        .then((response) => {
          // console.log(response.data);

          const { data } = response.data;
          this.customer = data
          this.progressPercentage();
        })
        .catch((e) => {
          console.log(e);
        });
    },

    handlePageChange(value) {
      this.page = value;
      this.retrieveCustomers();
    },

    refreshList() {
      this.retrieveCustomers();
      this.currentCustomer = null;
      this.currentIndex = -1;
    },

    setActiveCustomer(id, index) {
      this.retrieveCustomerDetail(id);
      this.currentCustomer = true;
      this.currentIndex = index;
    },

    progressPercentage() {
      const totalAmountToNextTier = 
        this.customer.amountSpentSinceStartDate + this.customer.amountToNextTier;

      const progress = 
        (this.customer.amountSpentSinceStartDate / totalAmountToNextTier) * 100;
      
      const remainingProgress = 100 - progress

      this.progress = progress
      this.progressText = `${remainingProgress.toFixed(0)}% to tier ${this.customer.nextTierToReach}`
    },
  },
  mounted() {
    this.retrieveCustomers();
  },

};
</script>

<style>
.progress {
  height: 100%;
  width: 100%;
  background-color: #fadb66;
  border-radius: 5px;
  overflow: hidden;
  box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
}

.progress-bar {
  height: 100%;
  color: #fff;
  text-align: center;
  line-height: 30px;
  background-color: #f23b26;
  transition: width 0.3s ease-in-out;
}

.custom-table {
  margin: 20px auto;
}

.custom-table td {
  padding: 10px;
  text-align: left;
  font-size: 18px;
  color: #042947; /* Default text color */
  background-color: #ffebe8; /* Default background color */
  transition: background-color 0.3s ease, color 0.3s ease;
}
</style>

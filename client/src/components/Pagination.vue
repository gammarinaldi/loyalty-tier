<template>
    <ul class="pagination">
    <li @click="prevPage" 
        :disabled="currentPage === 1" 
    >
        <a href="#">«</a>
    </li>
    <span v-for="pageNumber in totalPages" :key="pageNumber">
        <li @click="goToPage(pageNumber)">
            <a :class="{ active: currentPage === pageNumber }" href="#">{{ pageNumber }}</a>
        </li>
    </span>
    <li @click="nextPage" 
        :disabled="currentPage === totalPages" 
        :class="{ active: currentPage === pageNumber }"
    >
        <a href="#">»</a>
    </li>
  </ul>
</template>
<script>
export default {
    props: {
        totalItems: {
            type: Number,
            required: true,
        },
        itemsPerPage: {
            type: Number,
            required: true,
        },
    },
    data() {
        return {
            currentPage: 1,
            pageNumber: 0
        };
    },
    computed: {
        totalPages() {
            return Math.ceil(this.totalItems / this.itemsPerPage);
        },
    },
    methods: {
        nextPage() {
            if (this.currentPage < this.totalPages) {
                this.currentPage++;
                this.$emit("page-change", this.currentPage);
            }
        },
        prevPage() {
            if (this.currentPage > 1) {
                this.currentPage--;
                this.$emit("page-change", this.currentPage);
            }
        },
        goToPage(pageNumber) {
            if (pageNumber >= 1 && pageNumber <= this.totalPages) {
                this.currentPage = pageNumber;
                this.$emit("page-change", this.currentPage);
            }
        },
    },
};
</script>

<style scoped>
ul.pagination {
    display: inline-block;
    padding: 0;
    margin-top: 30px;
}

ul.pagination li {display: inline;}

ul.pagination li a {
    color: black;
    float: left;
    padding: 8px 16px;
    text-decoration: none;
    transition: background-color .3s;
    border: 1px solid #ddd;
}

ul.pagination li a.active {
    background-color: #f23b26;
    color: white;
    border: 1px solid #f23b26;
}

ul.pagination li a:hover:not(.active) {background-color: #ddd;}
</style>
  
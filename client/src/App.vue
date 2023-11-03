<script setup>
import { RouterLink, RouterView } from "vue-router";
</script>

<template>
  <header>
    <div class="wrapper">
      <nav class="topnav">
        <RouterLink  class="nav-link" to="/">Customers</RouterLink>
        <RouterLink  class="nav-link" to="/orders">Orders</RouterLink>
      </nav>
    </div>
  </header>

  <RouterView />
</template>

<template>
  <nav class="nav">
    <router-link to="/" exact-active-class="active"><v-icon size="20">mdi-home-outline</v-icon><span>Home</span></router-link>
    <router-link to="/plants" active-class="active"><v-icon size="20">mdi-sprout-outline</v-icon><span>Plants</span></router-link>
    <router-link to="/plantlogs" active-class="active"><v-icon size="20">mdi-notebook-outline</v-icon><span>Diary</span></router-link>
    <router-link to="/setting" active-class="active"><v-icon size="20">mdi-account-circle-outline</v-icon><span>Setting</span></router-link>
  </nav>
</template>
<script>
export default {
  name: 'NavBar',
};
</script>
<style scoped>
.nav {
  display: flex;
  gap: 4px;
  overflow-x: auto;
}

a {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  text-decoration: none;
  color: var(--leafy-muted);
  font-size: 0.95rem;
  font-weight: 600;
  padding: 8px 14px;
  border-radius: 10px;
  white-space: nowrap;
  transition: background-color 0.15s, color 0.15s;
}

a:hover {
  color: var(--leafy-text);
  background-color: var(--leafy-bg);
}

a.active {
  color: var(--leafy-green);
  background-color: var(--leafy-green-soft);
}

@media (max-width: 768px) {
  a {
    padding: 8px 10px;
  }

  a span {
    display: none;
  }
}
</style>

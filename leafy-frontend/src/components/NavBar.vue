<template>
  <nav>
    <ul>
      <li><router-link to="/">Home</router-link></li>
      <li><router-link to="/plants">Plants</router-link></li>
      <li><router-link to="/plantlogs">Diary</router-link></li>
      <li><router-link to="/setting">Setting</router-link></li>
    </ul>
  </nav>
</template>
<script>
export default {
  name: 'NavBar',
};
</script>
<style scoped>
nav {
  background-color: #ffffff;
  border-bottom: 2px solid #eaeaea;
}

ul {
  list-style: none;
  margin: 0;
  padding: 0;
  display: flex;
  justify-content: space-around;
  max-width: 960px;
  margin: 0 auto;
}

li {
  margin: 0;
  padding: 1rem;
}

a {
  text-decoration: none;
  color: #555;
  font-size: 1.1rem;
  font-weight: 500;
  transition: color 0.2s;
}

a:hover {
  color: #222;
}
</style>
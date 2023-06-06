<template>
  <div class="popup" v-if="popup.visible" 
    :style="{ 'background-color': popupBackgroundColor }">
    <p>{{ popup.message }}</p>
  </div>
</template>

<script>
import { mapState } from "vuex";

export default {
  name: "BasicPopup",
  computed: {
    ...mapState(["popup"]),
    popupBackgroundColor() {
      if (this.popup.status === "error") {
        return "#e74c3c"; // Red color for error status
      } else {
        return "#28a745"; // Default green color
      }
    }
  },
}
</script>
<style scoped>

.popup {
  position: fixed;
  bottom: 10px;
  left: 50%;
  transform: translateX(-50%);
  background-color: hsl(150, 100%, 29%);
  color: white;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
  padding: 0px 20px;
  z-index: 9999;
}

.popup h2 {
  font-size: 1.2rem;
  margin-bottom: 10px;
}

.popup p {
  font-size: 1rem;
  margin-bottom: 10px;
}

.popup button {
  font-size: 1rem;
  padding: 5px 10px;
  border: none;
}
</style>
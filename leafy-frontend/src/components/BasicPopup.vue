<template>
  <transition name="toast">
    <div class="popup" v-if="popup.visible" :class="popup.status === 'error' ? 'is-error' : 'is-success'">
      <v-icon size="20">{{ popup.status === 'error' ? 'mdi-alert-circle-outline' : 'mdi-check-circle-outline' }}</v-icon>
      <p>{{ popup.message }}</p>
    </div>
  </transition>
</template>

<script>
import { mapState } from "vuex";

export default {
  name: "BasicPopup",
  computed: {
    ...mapState(["popup"]),
  },
}
</script>
<style scoped>
.popup {
  position: fixed;
  bottom: 24px;
  left: 50%;
  transform: translateX(-50%);
  display: flex;
  align-items: center;
  gap: 8px;
  color: white;
  border-radius: 12px;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.18);
  padding: 12px 18px;
  z-index: 9999;
}

.popup.is-success {
  background-color: var(--leafy-green);
}

.popup.is-error {
  background-color: #B42318;
}

.popup p {
  margin: 0;
  font-size: 0.95rem;
  font-weight: 600;
}

.toast-enter-active,
.toast-leave-active {
  transition: opacity 0.2s, transform 0.2s;
}

.toast-enter-from,
.toast-leave-to {
  opacity: 0;
  transform: translate(-50%, 8px);
}
</style>

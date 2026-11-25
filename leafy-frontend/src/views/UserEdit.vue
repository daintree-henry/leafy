<template>
  <div class="page">
    <div class="leafy-card user-edit-container">
      <h2>사용자 정보 수정</h2>
      <form @submit.prevent="updateUser">
        <v-text-field id="name" v-model="name" label="이름" variant="outlined" color="#2F6B4F" required></v-text-field>
        <v-text-field id="password" v-model="password" label="새 비밀번호" type="password" variant="outlined" color="#2F6B4F" required></v-text-field>
        <div class="form-actions">
          <v-btn variant="text" @click="$router.back()">취소</v-btn>
          <button type="submit" class="btn-primary">수정하기</button>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
import { toRefs, reactive, computed } from 'vue';
import api from '@/api/api';
import { useRouter } from 'vue-router';
import { useStore } from 'vuex';

export default {
  name: 'UserEdit',
  setup() {
    const router = useRouter();
    const store = useStore();

    const user = computed(() => store.state.user);

    const editUser = reactive({
      name: user.value.name,
      password: '',
    });

    const updateUser = async () => {
      try {
        const userId = user.value.userId;
        await api.put(`/api/v1/users/${userId}`, editUser);
        alert('사용자 정보가 성공적으로 수정되었습니다. 다시 로그인 해주세요.');
        store.dispatch('logoutUser');
        router.push({ name: 'HomePage' });
      } catch (error) {
        console.error('사용자 정보 수정 중 오류가 발생했습니다.', error);
        alert('사용자 정보 수정 중 오류가 발생했습니다.');
      }
    };

    return {
      updateUser,
      ...toRefs(editUser),
    };
  },
};
</script>

<style scoped>
.user-edit-container {
  max-width: 440px;
  margin: 0 auto;
  padding: 28px;
}

h2 {
  margin: 0 0 20px;
  font-size: 1.2rem;
  font-weight: 800;
}

.form-actions {
  display: flex;
  justify-content: flex-end;
  align-items: center;
  gap: 8px;
}
</style>

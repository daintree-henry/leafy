<template>
  <div class="user-plants">
    <h3>내 식물 리스트</h3>
    <v-select
      :items="userPlantList"
      item-title="plantNicknameWithPlantName"
      item-value="userPlantId"
      label="식물 선택"
      v-model="userPlantId"
      dense
      @input="onSelectChange"
    ></v-select>
  </div>
</template>

<script>
import { ref, watch, onMounted } from 'vue';
import api from '@/api/api';

export default {
  name: 'UserPlants',
  props: {
    userId: {
      type: Number,
      required: true,
    },
  },
  setup(props, { emit }) {
    const userPlantList = ref([]);
    const userPlantId = ref(null);

    const fetchUserPlants = async () => {
      try {
        const response = await api.get(`/api/v1/user-plants/user/${props.userId}`);
        userPlantList.value = response.data.
        filter(plant => plant.plant !== null).
        map(plant => ({
          ...plant,
          plantNicknameWithPlantName: `${plant.plantNickname} (${plant.plant.plantName})`,
        }));
      } catch (error) {
        console.error(error);
      }
    };

    const onSelectChange = (value) =>{
      emit('updated-userplant-id', value);
    }

    onMounted(fetchUserPlants);

    watch(
      () => userPlantId.value,
      (newUserPlantId, oldUserPlantId) => {
        if (newUserPlantId !== oldUserPlantId) {
          onSelectChange(userPlantId.value);
        }
      }
    );


    return { userPlantList, userPlantId, onSelectChange };
  },
  
};
</script>

<style scoped>
.user-plants {
  padding: 1rem;
  border: 1px solid #ccc;
  border-radius: 4px;
  margin-bottom: 1rem;
}

h3 {
  margin-top: 0;
  margin-bottom: 1rem;
}
</style>
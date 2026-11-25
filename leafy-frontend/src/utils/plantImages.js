import { reactive } from 'vue';
import api from '@/api/api';

// 식물 사진 주소 모음. 내 식물·일기 API에는 사진 주소가 없어서 전체 식물 목록에서 찾아 쓴다.
const imageByPlantId = reactive({});
let loaded = false;

export function loadPlantImages() {
  if (loaded) return;
  loaded = true;
  api.get('/api/v1/plants')
    .then(response => {
      response.data.forEach(plant => {
        imageByPlantId[plant.plantId] = plant.imageUrl;
      });
    })
    .catch(error => {
      loaded = false;
      console.error(error);
    });
}

export function plantImage(plant) {
  if (!plant) return '';
  return plant.imageUrl || imageByPlantId[plant.plantId] || '';
}

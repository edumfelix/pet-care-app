using PetCareWebApi.Controllers.Data.ValueObject;
using System.Collections.Concurrent;

namespace PetCareWebApi.Patterns.Sigleton
{
    public sealed class HorarioCache
    {
        private static readonly Lazy<HorarioCache> _instance =
            new Lazy<HorarioCache>(() => new HorarioCache());

        private readonly ConcurrentDictionary<long, HorarioConsultaVO> _cache;

        private HorarioCache()
        {
            _cache = new ConcurrentDictionary<long, HorarioConsultaVO>();
        }

        public static HorarioCache Instance
        {
            get { return _instance.Value; }
        }

        public void AddOrUpdate(HorarioConsultaVO horario)
        {
            _cache.AddOrUpdate(horario.Id, horario, (key, oldValue) => horario);
        }

        public bool TryGetHorario(long id, out HorarioConsultaVO? horario)
        {
            return _cache.TryGetValue(id, out horario);
        }

        public void Remove(long id)
        {
            _cache.TryRemove(id, out _);
        }

        public void Clear()
        {
            _cache.Clear();
        }
    }
}

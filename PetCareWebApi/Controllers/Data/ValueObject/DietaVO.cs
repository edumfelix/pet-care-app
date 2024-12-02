namespace PetCareWebApi.Controllers.Data.ValueObject
    {
    public class DietaVO
        {
        public long Id { get; set; }
        public required long IdConsulta { get; set; }
        public required string RefeicoesJson { get; set; }
        }
    }

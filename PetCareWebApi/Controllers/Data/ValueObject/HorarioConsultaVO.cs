namespace PetCareWebApi.Controllers.Data.ValueObject
    {
    public class HorarioConsultaVO
        {
            public long Id { get; set; }
            public required string Horario { get; set; }
            public required bool Disponibilidade { get; set; }
        }
    }

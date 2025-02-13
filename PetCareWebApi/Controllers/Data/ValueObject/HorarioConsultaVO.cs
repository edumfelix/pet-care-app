namespace PetCareWebApi.Controllers.Data.ValueObject
    {
    public class HorarioConsultaVO
        {
            public long Id { get; set; }
            public required DateTime Horario { get; set; }
            public required bool Disponibilidade { get; set; }
        }
    }

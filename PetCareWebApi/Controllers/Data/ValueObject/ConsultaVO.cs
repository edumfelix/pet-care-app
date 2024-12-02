using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace PetCareWebApi.Controllers.Data.ValueObject
    {
    public class ConsultaVO
        {
        public long Id { get; set; }
        public required long IdHorario { get; set; }
        public required string IdVeterinario { get; set; }
        public required string IdTutor { get; set; }
        }
    }
